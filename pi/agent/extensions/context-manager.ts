/**
 * Context Manager Extension
 *
 * Adds commands to manage conversation context:
 * - /clear: Clear conversation and start fresh (preserves system)
 * - /compact-ctx: Manually trigger conversation compaction/summarization
 */

import type { ExtensionAPI, ExtensionCommandContext } from "@mariozechner/pi-coding-agent";

export default function (pi: ExtensionAPI) {
	// Track if we're in the middle of compacting to prevent double-clicks
	let isCompacting = false;

	/**
	 * /clear - Clear conversation history and start fresh
	 *
	 * Options:
	 * - Keep system prompt (default)
	 * - Full reset (including system context)
	 */
	pi.registerCommand("clear", {
		description: "Clear conversation history and start fresh",
		handler: async (_args: string, ctx: ExtensionCommandContext) => {
			const entries = ctx.sessionManager.getEntries();
			const msgCount = entries.filter((e) => e.type === "message").length;

			if (msgCount === 0) {
				ctx.ui.notify("Nothing to clear - conversation is already empty", "info");
				return;
			}

			// Confirm before clearing
			const confirmed = await ctx.ui.confirm(
				"Clear conversation?",
				`This will delete ${msgCount} messages and start fresh.\n\nThe system prompt and any custom instructions will be preserved.`,
				{ timeout: 10000 }
			);

			if (!confirmed) {
				ctx.ui.notify("Clear cancelled", "info");
				return;
			}

			// Create new session with same parent (preserves context chain)
			const result = await ctx.newSession({
				parentSession: ctx.sessionManager.getSessionFile(),
				setup: async (sm) => {
					// Optional: Add a "cleared" marker message
					sm.appendMessage({
						role: "user",
						content: [{ type: "text", text: "[Conversation cleared - starting fresh]" }],
						timestamp: Date.now(),
					});
				},
			});

			if (result.cancelled) {
				ctx.ui.notify("Clear cancelled by another extension", "warning");
			} else {
				ctx.ui.notify("✓ Conversation cleared - starting fresh", "success");
			}
		},
	});

	/**
	 * /compact-ctx - Manually trigger conversation compaction
	 *
	 * Summarizes the conversation to reduce token usage while preserving context.
	 * Useful when approaching context limits or when conversation gets too long.
	 */
	pi.registerCommand("compact-ctx", {
		description: "Summarize conversation to reduce token usage",
		handler: async (_args: string, ctx: ExtensionCommandContext) => {
			if (isCompacting) {
				ctx.ui.notify("Compaction already in progress...", "warning");
				return;
			}

			const usage = ctx.getContextUsage();
			if (!usage) {
				ctx.ui.notify("Unable to get context usage", "error");
				return;
			}

			// Show current status
			const tokenPercent = Math.round((usage.tokens / usage.maxTokens) * 100);
			const entries = ctx.sessionManager.getEntries();
			const msgCount = entries.filter((e) => e.type === "message").length;

			ctx.ui.notify(
				`Current: ${usage.tokens.toLocaleString()} / ${usage.maxTokens.toLocaleString()} tokens (${tokenPercent}%) · ${msgCount} messages`,
				"info"
			);

			// Ask for confirmation if context is healthy
			if (tokenPercent < 50 && msgCount < 20) {
				const confirmed = await ctx.ui.confirm(
					"Compact now?",
					`Context is healthy (${tokenPercent}% used).\nCompaction will summarize ${msgCount} messages.\n\nContinue anyway?`,
					{ timeout: 10000 }
				);
				if (!confirmed) {
					ctx.ui.notify("Compaction cancelled", "info");
					return;
				}
			}

			isCompacting = true;
			ctx.ui.setStatus("compact", "Compacting...");

			// Trigger compaction
			ctx.compact({
				customInstructions: "Create a comprehensive summary that preserves:\n1. All decisions made and their rationale\n2. Technical details, code patterns, and file changes\n3. Current state of any ongoing work\n4. Important context needed to continue effectively",
				onComplete: (result) => {
					isCompacting = false;
					ctx.ui.setStatus("compact", undefined);

					if (result.cancelled) {
						ctx.ui.notify("Compaction cancelled", "warning");
					} else {
						const newUsage = ctx.getContextUsage();
						const newPercent = newUsage
							? Math.round((newUsage.tokens / newUsage.maxTokens) * 100)
							: tokenPercent;
						const saved = usage.tokens - (newUsage?.tokens ?? usage.tokens);

						ctx.ui.notify(
							`✓ Compacted! ${saved > 0 ? `Saved ~${saved.toLocaleString()} tokens · ` : ""}Now at ${newPercent}%`,
							"success"
						);
					}
				},
				onError: (error) => {
					isCompacting = false;
					ctx.ui.setStatus("compact", undefined);
					ctx.ui.notify(`Compaction failed: ${error.message}`, "error");
				},
			});
		},
	});

	/**
	 * Auto-suggest compaction when context gets full
	 */
	pi.on("turn_end", async (_event, ctx) => {
		const usage = ctx.getContextUsage();
		if (!usage) return;

		const percent = (usage.tokens / usage.maxTokens) * 100;

		// Warn at 80%, suggest compact at 90%
		if (percent > 90 && !isCompacting) {
			const shouldCompact = await ctx.ui.confirm(
				"Context nearly full!",
				`Using ${Math.round(percent)}% of context window (${usage.tokens.toLocaleString()} tokens).\n\nCompact now to reduce token usage?`,
				{ timeout: 15000 }
			);

			if (shouldCompact) {
				// Trigger the compact-ctx command programmatically
				pi.sendUserMessage("/compact-ctx", { deliverAs: "followUp" });
			}
		} else if (percent > 80 && percent <= 90) {
			ctx.ui.setStatus("context", `⚠️ ${Math.round(percent)}% context used`);
		}
	});

	// Clear status when context drops
	pi.on("session_compact", async (_event, ctx) => {
		ctx.ui.setStatus("context", undefined);
	});

	// Also clear on new session
	pi.on("session_switch", async (_event, ctx) => {
		ctx.ui.setStatus("context", undefined);
		isCompacting = false;
	});
}
