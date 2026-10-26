// .opencode/plugins/ntfy-notify.js
//
// Opencode plugin: ntfy.sh push értesítés belső feladat befejezéskor.
//
// Mikor az opencode belső felada befejeződik (session.idle esemény),
// push értesítést küld az iPhone-ra az ntfy.sh szolgáltatáson keresztül.
//
// Beállítás:
//   1. Telepítse az ntfy appot az iPhone-ra (App Store)
//   2. Feliratkozzon egy témára, pl. "ai-ertesites-opencode"
//   3. Állítsa be a környezeti változót:
//      PowerShell:   $env:NTFY_TOPIC = "ai-ertesites-opencode"
//      CMD:          set NTFY_TOPIC=ai-ertesites-opencode
//      Linux/Mac:    export NTFY_TOPIC=ai-ertesites-opencode
//
// A plugin automatikusan betöltődik, amikor az opencode indul.

export const NtfyNotifyPlugin = async ({ directory }) => {
  const topic = process.env.NTFY_TOPIC || "ai-ertesites-opencode";
  const ntfyUrl = `https://ntfy.sh/${topic}`;

  return {
    event: async ({ event }) => {
      // session.idle = a feladat befejeződött, az opencode várakozik az új parancsra
      if (event.type === "session.idle") {
        const sessionId = event.properties?.sessionId || "ismeretlen";

        try {
          await fetch(ntfyUrl, {
            method: "POST",
            headers: { "Content-Type": "application/json" },
            body: JSON.stringify({
              title: "✅ Opencode feladat befejeződött",
              message: `Az opencode belső feladata sikeresen lefutott.\nSession: ${sessionId}`,
              priority: "default",
              tags: "white_check_mark",
            }),
          });
        } catch (err) {
          // Ne zárjuk be az opencode-ot, ha az értesítés sikertelen
          console.error("[ntfy-notify] Értesítés küldése sikertelen:", err.message);
        }
      }
    },
  };
};
