import { serve } from "https://deno.land/std@0.224.0/http/server.ts";

type VerifyPayload = {
  wasteType: "plastic" | "paper" | "glass" | "metal" | "organic";
  imageUrl?: string;
  weightKg?: number;
};

const bonuses: Record<VerifyPayload["wasteType"], number> = {
  plastic: 1.2,
  paper: 1,
  glass: 1.1,
  metal: 1.25,
  organic: 0.9,
};

serve(async (req) => {
  if (req.method !== "POST") {
    return new Response(JSON.stringify({ error: "Method not allowed" }), {
      status: 405,
      headers: { "Content-Type": "application/json" },
    });
  }

  let payload: VerifyPayload;

  try {
    payload = await req.json();
  } catch {
    return new Response(JSON.stringify({ error: "Invalid JSON payload" }), {
      status: 400,
      headers: { "Content-Type": "application/json" },
    });
  }

  if (!payload.wasteType) {
    return new Response(JSON.stringify({ error: "wasteType is required" }), {
      status: 400,
      headers: { "Content-Type": "application/json" },
    });
  }

  const weight = Math.max(payload.weightKg ?? 0, 0);
  const baseRate = 10;
  const multiplier = bonuses[payload.wasteType] ?? 1;
  const coinsEarned = Math.round(weight * baseRate * multiplier);

  const confidence = 0.8 + Math.random() * 0.19;
  const aiVerified = confidence >= 0.9;

  return new Response(
    JSON.stringify({
      aiVerified,
      confidence: Number(confidence.toFixed(2)),
      status: aiVerified ? "verified" : "manual_review",
      coinsEarned,
      reason: aiVerified
        ? null
        : "Image confidence below automatic verification threshold",
    }),
    { headers: { "Content-Type": "application/json" } },
  );
});
