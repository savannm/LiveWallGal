import Foundation

let browserHTML = """
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/@tabler/icons-webfont@3.19.0/dist/tabler-icons.min.css">
<style>
@import url('https://fonts.googleapis.com/css2?family=DM+Sans:wght@300;400;500;600&family=Space+Mono:wght@700&display=swap');
*{margin:0;padding:0;box-sizing:border-box}
:root{
  --surface2:rgba(255,255,255,0.04);
  --surface3:rgba(255,255,255,0.09);
  --border:rgba(255,255,255,0.07);
  --border2:rgba(255,255,255,0.15);
  --text:#f0f2f5;
  --muted:#8490a6;
  --green:#10b981;
  --amber:#f59e0b;
  --red:#f43f5e;
}
/* ── Themes ── */
body, body.theme-nebula {
  --bg:#05070f;
  --surface:rgba(10,14,26, var(--glass-opacity, 0.45));
  --accent:#0088ff;
  --accent2:#00e5ff;
  --accent-rgb:0, 136, 255;
  --accent2-rgb:0, 229, 255;
  --bg-gradient: radial-gradient(circle at top right, rgba(0, 136, 255, 0.08), transparent 45%), radial-gradient(circle at bottom left, rgba(0, 229, 255, 0.05), transparent 45%), var(--bg);
}
body.theme-aurora {
  --bg:#040907;
  --surface:rgba(8,18,14, var(--glass-opacity, 0.45));
  --accent:#10b981;
  --accent2:#00ffc4;
  --accent-rgb:16, 185, 129;
  --accent2-rgb:0, 255, 196;
  --bg-gradient: radial-gradient(circle at top right, rgba(16, 185, 129, 0.09), transparent 45%), radial-gradient(circle at bottom left, rgba(0, 255, 196, 0.05), transparent 45%), var(--bg);
}
body.theme-sunset {
  --bg:#08040a;
  --surface:rgba(22,10,26, var(--glass-opacity, 0.45));
  --accent:#f43f5e;
  --accent2:#ff7e40;
  --accent-rgb:244, 63, 94;
  --accent2-rgb:255, 126, 64;
  --bg-gradient: radial-gradient(circle at top right, rgba(244, 63, 94, 0.09), transparent 45%), radial-gradient(circle at bottom left, rgba(255, 126, 64, 0.05), transparent 45%), var(--bg);
}
body.theme-forest {
  --bg:#040a08;
  --surface:rgba(6,20,15, var(--glass-opacity, 0.45));
  --accent:#10b981;
  --accent2:#34d399;
  --accent-rgb:16,185,129;
  --accent2-rgb:52,211,153;
  --bg-gradient: radial-gradient(circle at top right, rgba(16, 185, 129, 0.08), transparent 45%), radial-gradient(circle at bottom left, rgba(52, 211, 153, 0.05), transparent 45%), var(--bg);
}
body.theme-sakura {
  --bg:#0a0408;
  --surface:rgba(22,8,18, var(--glass-opacity, 0.45));
  --accent:#ec4899;
  --accent2:#f472b6;
  --accent-rgb:236,72,153;
  --accent2-rgb:244,114,182;
  --bg-gradient: radial-gradient(circle at top right, rgba(236, 72, 153, 0.08), transparent 45%), radial-gradient(circle at bottom left, rgba(244, 114, 182, 0.05), transparent 45%), var(--bg);
}
body.theme-frost {
  --bg:#04070a;
  --surface:rgba(8,14,22, var(--glass-opacity, 0.45));
  --accent:#3b82f6;
  --accent2:#93c5fd;
  --accent-rgb:59,130,246;
  --accent2-rgb:147,197,253;
  --bg-gradient: radial-gradient(circle at top right, rgba(59, 130, 246, 0.08), transparent 45%), radial-gradient(circle at bottom left, rgba(147, 197, 253, 0.05), transparent 45%), var(--bg);
}
body.theme-solar {
  --bg:#0a0804;
  --surface:rgba(20,16,8, var(--glass-opacity, 0.45));
  --accent:#f59e0b;
  --accent2:#fbbf24;
  --accent-rgb:245,158,11;
  --accent2-rgb:251,191,36;
  --bg-gradient: radial-gradient(circle at top right, rgba(245, 158, 11, 0.08), transparent 45%), radial-gradient(circle at bottom left, rgba(251, 191, 36, 0.05), transparent 45%), var(--bg);
}
body.theme-amethyst {
  --bg:#07040a;
  --surface:rgba(16,8,22, var(--glass-opacity, 0.45));
  --accent:#8b5cf6;
  --accent2:#a78bfa;
  --accent-rgb:139,92,246;
  --accent2-rgb:167,139,250;
  --bg-gradient: radial-gradient(circle at top right, rgba(139, 92, 246, 0.08), transparent 45%), radial-gradient(circle at bottom left, rgba(167, 139, 250, 0.05), transparent 45%), var(--bg);
}
body.theme-light {
  --bg:#f4f6fa;
  --surface:rgba(255,255,255, var(--glass-opacity, 0.65));
  --surface2:rgba(0,0,0,0.03);
  --surface3:rgba(0,0,0,0.06);
  --border:rgba(0,0,0,0.06);
  --border2:rgba(0,0,0,0.12);
  --text:#1e293b;
  --muted:#64748b;
  --accent:#0088ff;
  --accent2:#02b5e2;
  --accent-rgb:0, 136, 255;
  --accent2-rgb:2, 181, 226;
  --bg-gradient: radial-gradient(circle at top right, rgba(0, 136, 255, 0.08), transparent 45%), radial-gradient(circle at bottom left, rgba(2, 181, 226, 0.05), transparent 45%), var(--bg);
}

/* ── Light Mode UI Overrides ── */
body.theme-light .sidebar {
  background: rgba(255, 255, 255, var(--glass-opacity, 0.5));
}
body.theme-light .topbar {
  background: rgba(255, 255, 255, calc(var(--glass-opacity, 0.45) * 0.78));
}
body.theme-light .settings-box {
  background: rgba(255, 255, 255, var(--glass-opacity, 0.85));
}
body.theme-light .home-hero h1 { background: linear-gradient(135deg, #1e293b, var(--accent)); -webkit-background-clip:text; -webkit-text-fill-color:transparent }
body.theme-light .card { background: rgba(0,0,0,0.015); }
body.theme-light .home-card { background: linear-gradient(135deg, rgba(0,0,0,0.02), rgba(0,0,0,0.005)); }
body.theme-light .video-row { background: var(--surface); }
body.theme-light .home-blob { opacity: 0.09; }
body.theme-light .btn-ghost {
  color: var(--text);
  border-color: rgba(0, 0, 0, 0.15);
  background: rgba(0, 0, 0, 0.02);
}
body.theme-light .sub-pill {
  background: linear-gradient(135deg, rgba(0, 136, 255, 0.08), rgba(2, 181, 226, 0.05));
  border-color: rgba(0, 136, 255, 0.2);
}
body.theme-light .sub-pill-text {
  color: var(--accent);
}

/* ── App Custom Backgrounds ── */
body.bg-default { --app-bg: var(--bg-gradient); }
body.bg-cosmic { --app-bg: radial-gradient(at 20% 20%, #0d061f 0px, transparent 50%), radial-gradient(at 80% 40%, #030308 0px, transparent 50%), radial-gradient(at 40% 80%, #240c3d 0px, transparent 50%), #040409; }
body.bg-aurora { --app-bg: radial-gradient(at 10% 30%, #022018 0px, transparent 50%), radial-gradient(at 90% 70%, #04090b 0px, transparent 50%), radial-gradient(at 50% 90%, #053d2d 0px, transparent 50%), #030605; }
body.bg-cyber { --app-bg: radial-gradient(at 80% 20%, #3d0525 0px, transparent 50%), radial-gradient(at 20% 80%, #0a041c 0px, transparent 50%), radial-gradient(at 50% 50%, #4f0322 0px, transparent 50%), #07030c; }

html,body{height:100%;overflow:hidden;background:var(--app-bg, var(--bg-gradient));color:var(--text);font-family:'DM Sans',sans-serif;font-size:14px;transition:background 0.3s}
body{display:flex;flex-direction:column}
.app-body{display:flex;flex:1;min-height:0;overflow:hidden}

/* ── Sidebar ── */
.sidebar{width:196px;min-width:196px;background:rgba(8,11,21, var(--glass-opacity, 0.5));-webkit-backdrop-filter:blur(20px);backdrop-filter:blur(20px);border-right:1px solid var(--border);display:flex;flex-direction:column;padding:16px 0;-webkit-app-region:drag}
.drag-handle{height:28px;flex-shrink:0}
.logo{padding:0 16px 16px;border-bottom:1px solid var(--border);margin-bottom:12px}
.logo span{font-family:'Space Mono',monospace;font-size:12px;font-weight:700;letter-spacing:.06em;color:var(--accent2)}
.logo small{display:block;font-size:9px;color:var(--muted);letter-spacing:.1em;text-transform:uppercase;margin-top:2px}
.nav-section{padding:0 10px;margin-bottom:6px}
.nav-label{font-size:9px;color:var(--muted);letter-spacing:.1em;text-transform:uppercase;padding:0 8px;margin-bottom:5px}
.nav-item{display:flex;align-items:center;gap:9px;padding:7px 9px;border-radius:7px;cursor:pointer;color:var(--muted);font-size:12px;transition:all .15s;border:1px solid transparent;-webkit-app-region:no-drag}
.nav-item:hover{background:var(--surface2);color:var(--text)}
.nav-item.active{background:var(--surface3);color:var(--text);border-color:var(--border2)}
.nav-item i{font-size:15px;flex-shrink:0}
.nbadge{margin-left:auto;font-size:9px;padding:1px 6px;border-radius:20px;font-weight:700;min-width:18px;text-align:center;background:var(--surface3);color:var(--muted)}
.nbadge.live{background:var(--accent);color:#fff}
.nbadge.pro{background:linear-gradient(135deg,var(--accent),var(--accent2));color:#fff}
.sidebar-bottom{margin-top:auto;padding:12px 10px 0;border-top:1px solid var(--border)}
.sub-pill{display:flex;align-items:center;gap:6px;padding:8px 10px;border-radius:8px;background:linear-gradient(135deg,rgba(0,136,255,.15),rgba(0,229,255,.1));border:1px solid rgba(0,136,255,.3);cursor:pointer;margin:0 0 8px;-webkit-app-region:no-drag}
.sub-pill i{font-size:14px;color:var(--accent2)}
.sub-pill-text{font-size:11px;font-weight:500;color:var(--accent2);flex:1}
.sub-pill small{font-size:9px;color:var(--muted)}

/* ── Settings modal ── */
.settings-overlay{display:none;position:fixed;inset:0;background:rgba(0,0,0,.6);z-index:150;align-items:center;justify-content:center}
.settings-overlay.open{display:flex}
.settings-box{background:rgba(10,14,26, var(--glass-opacity, 0.75));-webkit-backdrop-filter:blur(30px);backdrop-filter:blur(30px);border:1px solid var(--border2);border-radius:14px;width:360px;overflow:hidden}
.settings-hdr{display:flex;align-items:center;justify-content:space-between;padding:16px 18px 12px;border-bottom:1px solid var(--border)}
.settings-hdr h2{font-size:13px;font-weight:600;display:flex;align-items:center;gap:7px}
.settings-hdr h2 i{font-size:16px;color:var(--muted)}
.settings-close{background:transparent;border:none;color:var(--muted);font-size:18px;cursor:pointer;line-height:1;padding:2px}
.settings-close:hover{color:var(--text)}
.settings-body{padding:12px 18px 18px;display:flex;flex-direction:column;gap:6px}
.settings-section-label{font-size:9px;color:var(--muted);letter-spacing:.1em;text-transform:uppercase;padding:8px 0 4px;font-weight:600}
.settings-row{display:flex;align-items:center;gap:10px;padding:9px 12px;border-radius:8px;border:1px solid var(--border);background:var(--surface2);cursor:pointer;transition:all .15s}
.settings-row:hover{border-color:var(--border2);background:var(--surface3)}
.settings-row.danger:hover{border-color:rgba(248,113,113,.4);background:rgba(248,113,113,.07)}
.settings-row i{font-size:15px;color:var(--muted);flex-shrink:0}
.settings-row.danger i{color:var(--red)}
.settings-row-text{flex:1}
.settings-row-title{font-size:12px;font-weight:500;color:var(--text)}
.settings-row-sub{font-size:10px;color:var(--muted);margin-top:1px}
.settings-row.danger .settings-row-title{color:var(--red)}
.settings-row i.arrow{font-size:12px;color:var(--border2)}

/* ── Topbar ── */
.main{flex:1;display:flex;flex-direction:column;min-width:0;overflow:hidden}
.topbar{height:52px;background:rgba(8,11,21, calc(var(--glass-opacity, 0.45) * 0.78));-webkit-backdrop-filter:blur(20px);backdrop-filter:blur(20px);border-bottom:1px solid var(--border);display:flex;align-items:center;padding:0 16px;gap:12px;flex-shrink:0;-webkit-app-region:drag}
.topbar-title{font-size:13px;font-weight:600;-webkit-app-region:no-drag}
.search-wrap{flex:1;max-width:280px;position:relative;-webkit-app-region:no-drag}
.search-wrap i{position:absolute;left:10px;top:50%;transform:translateY(-50%);color:var(--muted);font-size:15px;pointer-events:none}
.search-wrap input{width:100%;background:var(--surface2);border:1px solid var(--border);border-radius:7px;padding:7px 10px 7px 32px;color:var(--text);font-family:'DM Sans',sans-serif;font-size:12px;outline:none}
.search-wrap input:focus{border-color:var(--accent)}
.search-wrap input::placeholder{color:var(--muted)}
.topbar-right{display:flex;align-items:center;gap:8px;margin-left:auto;-webkit-app-region:no-drag}
.btn{display:inline-flex;align-items:center;gap:5px;padding:6px 12px;border-radius:7px;border:none;cursor:pointer;font-family:'DM Sans',sans-serif;font-size:12px;font-weight:500;transition:all .15s}
.btn-ghost{background:transparent;color:var(--muted);border:1px solid var(--border)}
.btn-ghost:hover{background:var(--surface2);color:var(--text)}
.btn-primary{background:var(--accent);color:#fff}
.btn-primary:hover{background:#0077e6}
.btn-gradient{background:linear-gradient(135deg,var(--accent),var(--accent2));color:#fff;border:none}
.btn-gradient:hover{opacity:.9}
.btn i{font-size:14px}

/* ── Content ── */
.content-area{flex:1;overflow:hidden;display:flex}
.browser-pane{flex:1;overflow-y:auto;padding:16px;min-width:0}
.tabs-row{display:flex;align-items:center;gap:3px;margin-bottom:14px;flex-wrap:wrap}
.tab{padding:6px 14px;border-radius:8px;cursor:pointer;font-size:12px;font-weight:500;color:var(--muted);border:1px solid rgba(255,255,255,0.03);background:rgba(255,255,255,0.01);backdrop-filter:blur(8px);-webkit-backdrop-filter:blur(8px);transition:all .2s ease}
.tab:hover{color:var(--text);background:rgba(255,255,255,0.04);border-color:var(--border);transform:translateY(-1px)}
.tab.active{background:rgba(255,255,255,0.08);color:var(--text);border-color:var(--border2);box-shadow:0 4px 12px rgba(0,0,0,0.15), inset 0 1px 1px rgba(255,255,255,0.1)}
.spacer{flex:1}
.sort-select{background:var(--surface2);border:1px solid var(--border);color:var(--text);padding:6px 8px;border-radius:7px;font-family:'DM Sans',sans-serif;font-size:12px;cursor:pointer;outline:none}

/* ── Gallery Size controls ── */
.size-toggle-group{display:flex;background:var(--surface2);border:1px solid var(--border);border-radius:7px;padding:2px;gap:2px}
.size-btn{background:transparent;border:none;border-radius:5px;width:26px;height:26px;display:flex;align-items:center;justify-content:center;color:var(--muted);cursor:pointer;transition:all .15s}
.size-btn:hover{color:var(--text);background:rgba(255,255,255,0.04)}
.size-btn.active{color:var(--accent);background:var(--surface3);box-shadow:0 1px 3px rgba(0,0,0,0.15)}

/* ── Gallery ── */
.gallery{display:grid;grid-template-columns:repeat(auto-fill,minmax(190px,1fr));gap:12px}
.gallery.sz-small{grid-template-columns:repeat(auto-fill,minmax(130px,1fr));gap:10px}
.gallery.sz-medium{grid-template-columns:repeat(auto-fill,minmax(190px,1fr));gap:12px}
.gallery.sz-large{grid-template-columns:repeat(auto-fill,minmax(270px,1fr));gap:16px}

.card{background:rgba(255,255,255,0.02);border:1px solid var(--border);border-radius:10px;overflow:hidden;cursor:pointer;transition:all .2s;position:relative}
.card:hover{border-color:var(--border2);transform:translateY(-2px)}
.card.selected{border-color:var(--accent);box-shadow:0 0 0 1px var(--accent)}
.thumb{width:100%;aspect-ratio:16/9;position:relative;overflow:hidden;background:#000}
.thumb canvas,.thumb video{width:100%;height:100%;display:block;object-fit:cover}
.dur{position:absolute;bottom:6px;right:6px;background:rgba(0,0,0,.75);color:#fff;font-size:9px;font-family:'Space Mono',monospace;padding:2px 5px;border-radius:3px}
.lbl{position:absolute;top:6px;left:6px;font-size:9px;font-weight:700;padding:2px 6px;border-radius:3px;letter-spacing:.05em}
.lbl-new{background:var(--green);color:#030a06}
.lbl-trending{background:var(--red);color:#fff}
.lbl-mine{background:var(--accent);color:#fff}
.lbl-scanned{background:var(--amber);color:#1a1000}
.card-actions{position:absolute;top:6px;right:6px;display:flex;gap:4px;opacity:0;transition:opacity .15s}
.card:hover .card-actions{opacity:1}
.cab{width:24px;height:24px;border-radius:5px;background:rgba(0,0,0,.72);border:none;color:#fff;cursor:pointer;display:flex;align-items:center;justify-content:center;font-size:13px;transition:background .15s}
.cab.del:hover{background:var(--red)}
.card-info{padding:10px}
.card-title{font-size:12px;font-weight:500;white-space:nowrap;overflow:hidden;text-overflow:ellipsis;margin-bottom:5px}
.card-meta{display:flex;align-items:center;gap:6px;color:var(--muted);font-size:10px}
.cstat{display:flex;align-items:center;gap:2px}
.ccat{margin-left:auto;color:var(--accent2);font-size:10px}
.card-tags{display:flex;gap:4px;margin-top:7px;flex-wrap:wrap}
.ctag{font-size:9px;padding:2px 6px;border-radius:20px;border:1px solid var(--border);color:var(--muted)}

/* ── Local Videos view ── */
.scan-header{display:flex;align-items:center;gap:10px;margin-bottom:16px;padding:12px 14px;background:var(--surface);border:1px solid var(--border);border-radius:10px}
.scan-header i{font-size:20px;color:var(--accent2)}
.scan-header-text{flex:1}
.scan-header-text h3{font-size:13px;font-weight:600;margin-bottom:2px}
.scan-header-text p{font-size:11px;color:var(--muted)}
.scan-progress{margin-bottom:16px;display:none}
.prog-track{height:4px;background:var(--border2);border-radius:2px;overflow:hidden;margin-bottom:6px}
.prog-bar-fill{height:100%;background:var(--accent);border-radius:2px;transition:width .3s}
.prog-label{font-size:11px;color:var(--muted)}
.videos-toolbar{display:flex;align-items:center;gap:8px;margin-bottom:14px}
.vt-count{font-size:12px;color:var(--muted);flex:1}

/* List view for local videos */
.video-list{display:flex;flex-direction:column;gap:6px}
.video-row{display:flex;align-items:center;gap:12px;padding:10px 12px;background:var(--surface);border:1px solid var(--border);border-radius:8px;cursor:pointer;transition:all .15s}
.video-row:hover{border-color:var(--border2);background:var(--surface2)}
.video-row.selected{border-color:var(--accent)}
.vr-thumb{width:64px;height:36px;border-radius:5px;overflow:hidden;flex-shrink:0;background:#000}
.vr-thumb video,.vr-thumb canvas{width:100%;height:100%;object-fit:cover;display:block}
.vr-info{flex:1;min-width:0}
.vr-title{font-size:12px;font-weight:500;white-space:nowrap;overflow:hidden;text-overflow:ellipsis;margin-bottom:2px}
.vr-meta{font-size:10px;color:var(--muted);display:flex;gap:10px}
.vr-meta span{display:flex;align-items:center;gap:3px}
.vr-actions{display:flex;gap:4px;opacity:0;transition:opacity .15s}
.video-row:hover .vr-actions{opacity:1}

/* ── Preview panel ── */
.preview-panel{width:0;overflow:hidden;background:var(--surface);border-left:1px solid var(--border);display:flex;flex-direction:column;transition:width .3s ease;flex-shrink:0}
.preview-panel.open{width:290px}
.pv-inner{width:290px;display:flex;flex-direction:column;height:100%;overflow-y:auto}
.pv-header{padding:14px 14px;border-bottom:1px solid var(--border);display:flex;align-items:center;gap:8px;flex-shrink:0}
.pv-header h2{font-size:12px;font-weight:600;flex:1;white-space:nowrap;overflow:hidden;text-overflow:ellipsis}
.pv-close{background:transparent;border:none;color:var(--muted);cursor:pointer;font-size:17px;padding:2px;line-height:1}
.pv-close:hover{color:var(--text)}
.pv-thumb{width:100%;aspect-ratio:16/9;position:relative;overflow:hidden;flex-shrink:0;background:#000}
.pv-thumb canvas,.pv-thumb video{width:100%;height:100%;display:block;object-fit:cover}
.pv-play{position:absolute;inset:0;display:flex;align-items:center;justify-content:center;background:rgba(0,0,0,.3);cursor:pointer}
.pv-play i{font-size:36px;color:rgba(255,255,255,.85)}
.pv-body{padding:12px 14px;flex:1}
.pv-title{font-size:14px;font-weight:600;margin-bottom:6px}
.pv-meta{display:flex;gap:10px;color:var(--muted);font-size:11px;margin-bottom:14px;flex-wrap:wrap}
.pv-meta span{display:flex;align-items:center;gap:3px}
.slabel{font-size:10px;color:var(--muted);text-transform:uppercase;letter-spacing:.08em;margin-bottom:8px;font-weight:600}
.pv-tags{display:flex;flex-wrap:wrap;gap:5px;margin-bottom:14px}
.pv-tag{font-size:11px;padding:3px 9px;border-radius:20px;border:1px solid var(--border2);color:var(--muted)}
.pv-actions{display:flex;flex-direction:column;gap:7px;margin-bottom:14px}
.pvbtn{display:flex;align-items:center;justify-content:center;gap:6px;padding:8px;border-radius:8px;border:none;cursor:pointer;font-family:'DM Sans',sans-serif;font-size:12px;font-weight:600;transition:all .15s;width:100%}
.pvbtn-apply{background:var(--accent);color:#fff}
.pvbtn-apply:hover{background:#0077e6}
.pvbtn-sec{background:var(--surface2);color:var(--text);border:1px solid var(--border2)}
.pvbtn-sec:hover{background:var(--surface3)}
.pvbtn-del{background:transparent;color:var(--red);border:1px solid rgba(248,113,113,.35)}
.pvbtn-del:hover{background:rgba(248,113,113,.08)}
.pv-row{display:flex;justify-content:space-between;font-size:11px;padding:5px 0;border-bottom:1px solid var(--border)}
.pv-row:last-child{border-bottom:none}
.pv-row .l2{color:var(--muted)}
.pv-row .v2{color:var(--text);font-weight:500;max-width:150px;overflow:hidden;text-overflow:ellipsis;white-space:nowrap}

/* ── Music Bar ── */
.music-bar{flex-shrink:0;background:var(--surface);border-top:1px solid var(--border);height:64px;display:flex;align-items:center;padding:0 14px;gap:10px;-webkit-app-region:no-drag}
.music-bar.hidden{display:none}
.music-art{width:38px;height:38px;border-radius:6px;background:var(--surface2);border:1px solid var(--border2);display:flex;align-items:center;justify-content:center;flex-shrink:0;overflow:hidden}
.music-art i{font-size:18px;color:var(--muted)}
.music-art canvas{width:100%;height:100%;display:block}
.music-info{min-width:0;width:130px}
.music-title{font-size:11px;font-weight:500;white-space:nowrap;overflow:hidden;text-overflow:ellipsis}
.music-artist{font-size:10px;color:var(--muted);margin-top:1px}
.music-controls{display:flex;align-items:center;gap:2px}
.mc{width:28px;height:28px;border-radius:6px;background:transparent;border:none;color:var(--muted);cursor:pointer;display:flex;align-items:center;justify-content:center;font-size:15px;transition:all .15s}
.mc:hover{background:var(--surface2);color:var(--text)}
.mc.play{width:34px;height:34px;background:var(--accent);color:#fff;border-radius:50%;font-size:16px}
.mc.play:hover{background:#0077e6}
.mc.on{background:rgba(0,136,255,.16);color:var(--accent2);border:1px solid rgba(0,136,255,.25)}
.music-prog{flex:1;display:flex;flex-direction:column;gap:3px;max-width:220px}
.pbar{width:100%;height:3px;background:var(--border2);border-radius:2px;cursor:pointer;overflow:hidden}
.pfill{height:100%;background:var(--accent);border-radius:2px;transition:width .1s linear;pointer-events:none}
.ptimes{display:flex;justify-content:space-between;font-size:9px;color:var(--muted);font-family:'Space Mono',monospace}
.music-vol{display:flex;align-items:center;gap:5px}
.music-vol i{font-size:14px;color:var(--muted);cursor:pointer}
.vslider{width:64px;height:3px;accent-color:var(--accent);cursor:pointer}

/* ── Paywall Modal ── */
.overlay{display:none;position:fixed;inset:0;background:rgba(0,0,0,.7);z-index:200;align-items:center;justify-content:center}
.overlay.open{display:flex}
.pw-box{background:var(--surface);border:1px solid var(--border2);border-radius:16px;width:440px;overflow:hidden}
.pw-hero{background:linear-gradient(135deg,#1a0a3a,#0d0020,#0a0a1f);padding:32px 28px 24px;text-align:center;position:relative}
.pw-hero::before{content:'';position:absolute;inset:0;background:radial-gradient(ellipse at 50% 0%,rgba(0,136,255,.3),transparent 70%)}
.pw-icon{font-size:44px;color:var(--accent2);margin-bottom:12px;position:relative}
.pw-title{font-size:22px;font-weight:700;margin-bottom:6px;position:relative}
.pw-subtitle{font-size:13px;color:var(--muted);line-height:1.5;position:relative}
.pw-body{padding:24px 28px}
.pw-price{text-align:center;margin-bottom:20px}
.pw-price .amount{font-size:36px;font-weight:700;color:var(--text)}
.pw-price .per{font-size:14px;color:var(--muted)}
.pw-price .trial{font-size:11px;color:var(--green);margin-top:4px}
.pw-features{display:flex;flex-direction:column;gap:9px;margin-bottom:22px}
.pw-feat{display:flex;align-items:center;gap:10px;font-size:13px}
.pw-feat i{font-size:16px;color:var(--green);flex-shrink:0}
.pw-feat .feat-lock{color:var(--muted)}
.pw-cta{width:100%;padding:13px;background:linear-gradient(135deg,var(--accent),var(--accent2));color:#fff;border:none;border-radius:10px;font-family:'DM Sans',sans-serif;font-size:14px;font-weight:700;cursor:pointer;margin-bottom:10px;transition:opacity .15s}
.pw-cta:hover{opacity:.92}
.pw-links{display:flex;justify-content:center;gap:16px;font-size:11px;color:var(--muted)}
.pw-links a{color:var(--muted);text-decoration:none;cursor:pointer}
.pw-links a:hover{color:var(--text)}
.pw-close-btn{position:absolute;top:12px;right:12px;background:rgba(255,255,255,.08);border:none;color:var(--muted);font-size:16px;cursor:pointer;width:28px;height:28px;border-radius:6px;display:flex;align-items:center;justify-content:center}

/* ── Upload Modal ── */
.modal-overlay{display:none;position:fixed;inset:0;background:rgba(0,0,0,.6);z-index:100;align-items:center;justify-content:center}
.modal-overlay.open{display:flex}
.mbox{background:var(--surface);border:1px solid var(--border2);border-radius:14px;padding:24px;width:400px;max-height:90vh;overflow-y:auto}
.mhdr{display:flex;align-items:center;justify-content:space-between;margin-bottom:18px}
.mtitle{font-size:14px;font-weight:600}
.mclose{background:transparent;border:none;color:var(--muted);font-size:18px;cursor:pointer;line-height:1}
.mclose:hover{color:var(--text)}
.dropzone{border:2px dashed var(--border2);border-radius:10px;padding:26px 16px;text-align:center;cursor:pointer;transition:all .2s;background:var(--surface2)}
.dropzone:hover,.dropzone.drag{border-color:var(--accent);background:rgba(0,136,255,.07)}
.dropzone.has-file{border-color:var(--green);background:rgba(52,211,153,.05)}
.dropzone i{font-size:30px;color:var(--accent);margin-bottom:10px;display:block;transition:color .2s}
.dropzone.has-file i{color:var(--green)}
.dropzone p{color:var(--muted);font-size:12px;line-height:1.6}
.dropzone p strong{color:var(--text)}
.fname{display:none;font-size:11px;color:var(--green);margin-top:5px;word-break:break-all}
.fcol{display:flex;flex-direction:column;gap:10px;margin-top:14px}
.fg{display:flex;flex-direction:column;gap:4px}
.flabel{font-size:11px;color:var(--muted);font-weight:500}
.fi{background:var(--surface2);border:1px solid var(--border);border-radius:7px;padding:7px 10px;color:var(--text);font-family:'DM Sans',sans-serif;font-size:12px;outline:none;width:100%}
.fi:focus{border-color:var(--accent)}
.frow{display:grid;grid-template-columns:1fr 1fr;gap:8px}
.fs{background:var(--surface2);border:1px solid var(--border);border-radius:7px;padding:7px 10px;color:var(--text);font-family:'DM Sans',sans-serif;font-size:12px;outline:none;width:100%;cursor:pointer}
.sbtn{width:100%;padding:9px;border:none;border-radius:7px;font-family:'DM Sans',sans-serif;font-size:13px;font-weight:600;cursor:pointer;margin-top:4px;transition:all .15s}
.sbtn:not(:disabled){background:var(--accent);color:#fff}
.sbtn:not(:disabled):hover{background:#0077e6}
.sbtn:disabled{background:var(--surface3);color:var(--muted);cursor:not-allowed}

/* Empty state */
.empty{display:flex;flex-direction:column;align-items:center;justify-content:center;padding:50px 20px;text-align:center;gap:10px;color:var(--muted)}
.empty i{font-size:42px;color:var(--border2)}
.empty h3{font-size:13px;font-weight:600;color:var(--text)}
.empty p{font-size:12px;line-height:1.6;max-width:240px}

/* Toast */
.toast{position:fixed;top:24px;left:50%;transform:translateX(-50%) translateY(-60px);background:var(--surface3);border:1px solid var(--border2);color:var(--text);padding:8px 18px;border-radius:8px;font-size:12px;font-weight:500;transition:transform .25s ease;z-index:999;pointer-events:none;white-space:nowrap}
.toast.show{transform:translateX(-50%) translateY(0)}

/* ── Browse Online section ── */
.bo-section{margin-top:28px;padding-top:20px;border-top:1px solid var(--border)}
.bo-hdr{display:flex;align-items:center;gap:10px;margin-bottom:14px}
.bo-hdr-text h3{font-size:13px;font-weight:600;color:var(--text);margin-bottom:2px}
.bo-hdr-text p{font-size:11px;color:var(--muted)}
.bo-hdr-logo{display:flex;align-items:center;gap:6px;margin-left:auto;color:var(--muted);font-size:11px;text-decoration:none;cursor:pointer;padding:4px 10px;border-radius:6px;border:1px solid var(--border);transition:all .15s}
.bo-hdr-logo:hover{border-color:var(--border2);color:var(--text)}
.bo-hdr-logo i{font-size:13px}
.bo-grid{display:grid;grid-template-columns:repeat(auto-fill,minmax(200px,1fr));gap:12px}
.bo-card{background:var(--surface);border:1px solid var(--border);border-radius:10px;overflow:hidden;cursor:pointer;transition:all .2s;position:relative}
.bo-card:hover{border-color:var(--border2);transform:translateY(-2px);box-shadow:0 8px 28px rgba(0,0,0,.45)}
.bo-thumb{width:100%;aspect-ratio:16/9;position:relative;overflow:hidden;background:#000}
.bo-thumb img{width:100%;height:100%;object-fit:cover;display:block;transition:opacity .3s}
.bo-thumb video{position:absolute;inset:0;width:100%;height:100%;object-fit:cover;opacity:0;transition:opacity .4s}
.bo-card:hover .bo-thumb video{opacity:1}
.bo-card:hover .bo-thumb img{opacity:0}
.bo-ext{position:absolute;top:6px;right:6px;background:rgba(0,0,0,.65);color:rgba(255,255,255,.85);font-size:9px;padding:2px 6px;border-radius:3px;display:flex;align-items:center;gap:3px;transition:opacity .15s}
.bo-cat-badge{position:absolute;top:6px;left:6px;font-size:9px;font-weight:700;padding:2px 6px;border-radius:3px;letter-spacing:.04em;text-transform:uppercase}
.bo-info{padding:9px 11px}
.bo-title{font-size:12px;font-weight:500;white-space:nowrap;overflow:hidden;text-overflow:ellipsis;margin-bottom:3px;color:var(--text)}
.bo-meta{font-size:10px;color:var(--muted);display:flex;align-items:center;gap:5px}
.bo-meta i{font-size:11px}
.bo-topbar{display:flex;align-items:center;justify-content:space-between;padding:12px 14px;margin-bottom:14px;background:var(--surface);border:1px solid var(--border);border-radius:10px}
.bo-dl-btn{position:absolute;top:6px;right:6px;background:rgba(0,0,0,.72);color:#fff;border:none;border-radius:5px;font-size:10px;font-weight:600;padding:4px 8px;cursor:pointer;display:flex;align-items:center;gap:4px;transition:background .15s;-webkit-app-region:no-drag}
.bo-dl-btn:hover{background:var(--accent)}
@keyframes spin{to{transform:rotate(360deg)}}
.bo-search-container{position:relative;display:flex;align-items:center}
.bo-search-container i{position:absolute;left:10px;color:var(--muted);font-size:13px;pointer-events:none}
.bo-search-box{background:var(--surface2);border:1px solid var(--border);border-radius:6px;padding:5px 8px 5px 28px;color:var(--text);font-family:inherit;font-size:11px;width:150px;outline:none;transition:border-color .15s}
.bo-search-box:focus{border-color:var(--accent)}

/* ── Dashboard Glassmorphism ── */
.home-container{padding:24px 20px;display:flex;flex-direction:column;gap:24px;overflow-y:auto;height:100%}
.home-hero{background:linear-gradient(135deg, rgba(255,255,255,0.03), rgba(255,255,255,0.01));border:1px solid var(--border);border-radius:16px;padding:32px;position:relative;overflow:hidden;backdrop-filter:blur(10px);box-shadow:0 8px 32px 0 rgba(0,0,0,0.2)}
.home-hero::after{content:'';position:absolute;inset:0;background:radial-gradient(circle at 100% 0%, rgba(var(--accent-rgb), 0.15), transparent 60%)}
.home-hero h1{font-size:24px;font-weight:600;margin-bottom:6px;background:linear-gradient(135deg, #fff, var(--accent2));-webkit-background-clip:text;-webkit-text-fill-color:transparent}
.home-hero p{font-size:13px;color:var(--muted);max-width:480px;line-height:1.5}
.home-grid{display:grid;grid-template-columns:repeat(auto-fit, minmax(220px, 1fr));gap:20px}
.home-card{background:linear-gradient(135deg, rgba(255,255,255,0.05), rgba(255,255,255,0.01));border:1px solid var(--border);border-radius:14px;padding:24px;display:flex;flex-direction:column;gap:14px;cursor:pointer;transition:all 0.4s cubic-bezier(0.25, 0.8, 0.25, 1);backdrop-filter:blur(15px);position:relative;box-shadow:0 8px 32px 0 rgba(0,0,0,0.15);perspective:1000px;transform-style:preserve-3d;transform:translateZ(0)}
.home-card:hover{transform:translateY(-6px) rotateX(4deg) rotateY(-2deg);border-color:var(--border2);box-shadow:0 20px 40px rgba(0,0,0,0.3), inset 0 0 20px rgba(255,255,255,0.05)}
.home-card::before{content:'';position:absolute;inset:0;border-radius:14px;background:linear-gradient(135deg, var(--accent), var(--accent2));opacity:0;transition:opacity 0.4s;z-index:-1;filter:blur(20px)}
.home-card:hover::before{opacity:0.12}
.hc-icon{width:44px;height:44px;border-radius:10px;background:var(--surface2);border:1px solid var(--border);display:flex;align-items:center;justify-content:center;font-size:20px;color:var(--accent2);transition:all 0.3s;box-shadow:0 4px 12px rgba(0,0,0,0.1)}
.home-card:hover .hc-icon{background:linear-gradient(135deg, var(--accent), var(--accent2));color:#fff;box-shadow:0 8px 20px rgba(0,136,255,0.25);transform:translateZ(20px)}
.hc-title{font-size:14px;font-weight:600;color:var(--text);transform:translateZ(10px)}
.hc-desc{font-size:11px;color:var(--muted);line-height:1.5;transform:translateZ(5px)}
.hc-stats{margin-top:auto;display:flex;align-items:center;justify-content:space-between;border-top:1px solid var(--border);padding-top:10px;font-size:10px;color:var(--muted);transform:translateZ(8px)}
.hc-count{background:var(--surface3);color:var(--text);padding:2px 8px;border-radius:20px;font-weight:600}

/* ── Homepage Glass Decoration Blobs ── */
.home-blob{position:absolute;border-radius:50%;opacity:0.16;z-index:0;pointer-events:none;animation:floatBlob 22s infinite alternate ease-in-out;will-change:transform;transform:translate3d(0,0,0)}
.blob-1{width:320px;height:320px;background:radial-gradient(circle, var(--accent) 0%, transparent 68%);top:10%;left:15%}
.blob-2{width:280px;height:280px;background:radial-gradient(circle, var(--accent2) 0%, transparent 68%);bottom:15%;right:10%;animation-delay:-4s}
.blob-3{width:240px;height:240px;background:radial-gradient(circle, var(--red) 0%, transparent 68%);top:40%;left:55%;animation-delay:-8s}
@keyframes floatBlob{
  0%{transform:translate3d(0,0,0) scale(1)}
  100%{transform:translate3d(40px, 30px, 0) scale(1.12)}
}

/* ── App Background Selection Styles ── */
.bg-selector-group{display:grid;grid-template-columns:repeat(4, 1fr);gap:6px;margin-top:8px}
.bg-btn{background:var(--surface2);border:1px solid var(--border);border-radius:6px;padding:6px;cursor:pointer;color:var(--muted);font-size:9px;font-weight:500;text-align:center;transition:all 0.15s;font-family:inherit}
.bg-btn:hover{border-color:var(--border2);color:var(--text);background:var(--surface3)}
.bg-btn.active{border-color:var(--accent);color:var(--text);background:var(--surface3);box-shadow:0 0 0 1px var(--accent)}

/* ── Theme settings selector ── */
.theme-selector-group{display:grid;grid-template-columns:repeat(4, 1fr);gap:6px;margin-top:8px}
.theme-btn{background:var(--surface2);border:1px solid var(--border);border-radius:8px;padding:8px 6px;cursor:pointer;color:var(--muted);display:flex;flex-direction:column;align-items:center;gap:5px;transition:all 0.15s;font-family:inherit;font-size:9px;font-weight:500}
.theme-btn:hover{border-color:var(--border2);color:var(--text);background:var(--surface3)}
.theme-btn.active{border-color:var(--accent);color:var(--text);background:var(--surface3);box-shadow:0 0 0 1px var(--accent)}
.theme-dot{width:14px;height:14px;border-radius:50%;display:block}

/* ── Custom Background Image Overlay ── */
#customBgImage {
  position: fixed;
  inset: 0;
  z-index: -2;
  pointer-events: none;
  background-size: cover;
  background-position: center;
  opacity: var(--bg-image-opacity, 0.3);
  transition: opacity 0.2s ease;
  display: none;
}
</style>
</head>
<body>
<div id="customBgImage"></div>

<div class="app-body">
  <!-- Sidebar -->
  <div class="sidebar">
    <div class="drag-handle"></div>
    <div class="logo" style="display:flex;align-items:center;gap:10px">
      <div style="width:28px;height:28px;border-radius:6px;background:linear-gradient(135deg,var(--accent),var(--accent2));display:flex;align-items:center;justify-content:center;color:#fff;flex-shrink:0">
        <i class="ti ti-sparkles" style="font-size:16px"></i>
      </div>
      <div>
        <span style="color:var(--text)">LIVE WALLPAPER</span>
        <small>Wallpaper Studio</small>
      </div>
    </div>

    <div class="nav-section">
      <div class="nav-label">Browse</div>
      <div class="nav-item active" id="nav-home" onclick="switchView('home',this)"><i class="ti ti-home"></i> Home</div>
      <div class="nav-item" id="nav-browse" onclick="switchView('browse',this)"><i class="ti ti-layout-grid"></i> All Wallpapers</div>
      <div class="nav-item" id="nav-online" onclick="switchView('online',this)"><i class="ti ti-world-download"></i> Browse Online</div>
    </div>

    <div class="nav-section" style="margin-top:8px">
      <div class="nav-label">Library</div>
      <div class="nav-item" id="nav-uploads" onclick="switchView('uploads',this)">
        <i class="ti ti-upload"></i> Video Collection <span class="nbadge" id="ucnt">0</span>
      </div>
      <div class="nav-item" id="nav-videos" onclick="switchView('videos',this)">
        <i class="ti ti-folder-search"></i> Local Videos <span class="nbadge" id="vcnt">0</span>
      </div>
      <div class="nav-item" id="nav-saved" onclick="switchView('saved',this)"><i class="ti ti-heart"></i> Favourite</div>
    </div>

    <div class="sidebar-bottom">
      <!-- Settings nav item -->
      <div class="nav-item" onclick="openSettings()" style="margin-bottom:6px">
        <i class="ti ti-settings"></i> Settings
      </div>
      <!-- Subscription pill — updated dynamically -->
      <div class="sub-pill" id="subPill" onclick="showPaywall()">
        <i class="ti ti-crown"></i>
        <div style="flex:1;min-width:0">
          <div class="sub-pill-text" id="subPillText">Upgrade to Pro</div>
          <small id="subPillSub">7-day free trial</small>
        </div>
      </div>

    </div>
  </div>

  <!-- Main -->
  <div class="main">
    <div class="topbar">
      <span class="topbar-title" id="topbarTitle">All Wallpapers</span>
      <div class="search-wrap">
        <i class="ti ti-search"></i>
        <input type="text" placeholder="Search…" oninput="onSearch(this.value)">
      </div>
      <div class="topbar-right" id="topbarRight">
        <div class="size-toggle-group" id="sizeToggleGroup">
          <button class="size-btn" id="sz-small" title="Small" onclick="setGallerySize('small',this)"><i class="ti ti-layout-grid-add"></i></button>
          <button class="size-btn active" id="sz-medium" title="Medium" onclick="setGallerySize('medium',this)"><i class="ti ti-layout-grid"></i></button>
          <button class="size-btn" id="sz-large" title="Large" onclick="setGallerySize('large',this)"><i class="ti ti-layout-2"></i></button>
        </div>
      </div>
    </div>

    <div class="content-area">
      <div class="browser-pane" id="mainPane">

        <!-- Home Dashboard -->
        <div id="homeView" style="position:relative;overflow:hidden">
          <div class="home-blob blob-1"></div>
          <div class="home-blob blob-2"></div>
          <div class="home-blob blob-3"></div>
          <div class="home-container">
            <div class="home-hero" style="z-index:1">
              <h1>Welcome to Wallpaper Studio</h1>
              <p>Explore gorgeous, low-CPU interactive live wallpapers, curate your personal collections, and sync background soundscape playlists.</p>
            </div>
            
            <div class="home-grid">
              <!-- All Wallpapers -->
              <div class="home-card" onclick="switchView('browse', document.getElementById('nav-browse'))">
                <div class="hc-icon"><i class="ti ti-layout-grid"></i></div>
                <div class="hc-title">All Wallpapers</div>
                <div class="hc-desc">Explore the standard built-in interactive shaders, HTML particles, and creative presets.</div>
                <div class="hc-stats">
                  <span>Wallpapers</span>
                  <span class="hc-count" id="hsAll">17</span>
                </div>
              </div>
              
              <!-- Browse Online -->
              <div class="home-card" onclick="switchView('online', document.getElementById('nav-online'))">
                <div class="hc-icon"><i class="ti ti-world-download"></i></div>
                <div class="hc-title">Browse Online</div>
                <div class="hc-desc">Download thousands of community-uploaded animated backgrounds instantly.</div>
                <div class="hc-stats">
                  <span>Source</span>
                  <span class="hc-count">wallsflow.com</span>
                </div>
              </div>
              
              <!-- Video Collection -->
              <div class="home-card" onclick="switchView('uploads', document.getElementById('nav-uploads'))">
                <div class="hc-icon"><i class="ti ti-upload"></i></div>
                <div class="hc-title">Video Collection</div>
                <div class="hc-desc">Your uploaded movie wallpapers. Add your personal MP4/MOV files to use as wallpaper.</div>
                <div class="hc-stats">
                  <span>Items</span>
                  <span class="hc-count" id="hsCollection">0</span>
                </div>
              </div>
              
              <!-- Local Videos -->
              <div class="home-card" onclick="switchView('videos', document.getElementById('nav-videos'))">
                <div class="hc-icon"><i class="ti ti-folder-search"></i></div>
                <div class="hc-title">Local Videos</div>
                <div class="hc-desc">Scan any directories on your Mac to automatically index and play your local videos.</div>
                <div class="hc-stats">
                  <span>Scanned</span>
                  <span class="hc-count" id="hsLocal">0</span>
                </div>
              </div>
              
              <!-- Favourites -->
              <div class="home-card" onclick="switchView('saved', document.getElementById('nav-saved'))">
                <div class="hc-icon"><i class="ti ti-heart"></i></div>
                <div class="hc-title">Favourites</div>
                <div class="hc-desc">Your curated list of beautiful, hearted live backgrounds.</div>
                <div class="hc-stats">
                  <span>Saved</span>
                  <span class="hc-count" id="hsFav">0</span>
                </div>
              </div>
            </div>
          </div>
        </div>

        <!-- Browse / Trending / New -->
        <div id="browseView">
          <div class="tabs-row">
            <div class="tab active" onclick="setTab(this,'All')">All</div>
            <div class="tab" onclick="setTab(this,'Abstract')">Abstract</div>
            <div class="tab" onclick="setTab(this,'Anime')">Anime</div>
            <div class="tab" onclick="setTab(this,'Nature')">Nature</div>
            <div class="tab" onclick="setTab(this,'Sci-Fi')">Sci-Fi</div>
            <div class="tab" onclick="setTab(this,'Gaming')">Gaming</div>
            <div class="spacer"></div>
            <select class="sort-select" onchange="renderBrowse()"><option>Most Recent</option><option>Most Viewed</option><option>Most Liked</option></select>
          </div>
          <div class="gallery" id="browseGallery"></div>
        </div>

        <!-- Browse Online -->
        <div id="onlineView" style="display:none">
          <div class="bo-topbar">
            <div>
              <div style="font-size:12px;font-weight:600;color:var(--text);margin-bottom:2px">Online Wallpapers</div>
              <div style="font-size:11px;color:var(--muted)">Hover to preview • Download button saves to your folder</div>
            </div>
            <div style="display:flex;align-items:center;gap:12px">
              <div class="bo-search-container">
                <i class="ti ti-search"></i>
                <input type="text" class="bo-search-box" id="boSearchInput" placeholder="Search wallpapers..." oninput="onOnlineSearchInputChanged()">
              </div>
              <div class="bo-hdr-logo" onclick="openExternalURL('https://wallsflow.com/live-wallpapers/')">
                <i class="ti ti-external-link"></i> Open site
              </div>
            </div>
          </div>
          <div class="bo-grid" id="boGrid"></div>
        </div>

        <!-- My Uploads -->
        <div id="uploadsView" style="display:none">
          <div style="display:flex;align-items:center;justify-content:space-between;margin-bottom:14px">
            <span style="font-size:12px;color:var(--muted)" id="uploadsSub">Your uploaded wallpapers</span>
            <button class="btn btn-primary" onclick="openUploadModal()"><i class="ti ti-plus"></i> Add Video</button>
          </div>
          <div class="gallery" id="uploadsGallery"></div>
        </div>

        <!-- Local Videos (folder scan) -->
        <div id="videosView" style="display:none">
          <div class="scan-header">
            <i class="ti ti-folder-search"></i>
            <div class="scan-header-text">
              <h3>Scan a Folder</h3>
              <p>Find all video files in a folder and apply them as wallpapers</p>
            </div>
            <button class="btn btn-gradient" onclick="triggerScan()"><i class="ti ti-scan"></i> Scan Folder</button>
          </div>
          <div class="scan-progress" id="scanProgress">
            <div class="prog-track"><div class="prog-bar-fill" id="scanBar" style="width:0%"></div></div>
            <div class="prog-label" id="scanLabel">Scanning…</div>
          </div>
          <div class="videos-toolbar" id="videosToolbar" style="display:none">
            <span class="vt-count" id="vtCount">0 videos</span>
            <button class="btn btn-ghost" onclick="triggerScan()"><i class="ti ti-refresh"></i> Rescan</button>
            <button class="btn btn-ghost" style="color:var(--red)" onclick="clearScanned()"><i class="ti ti-trash"></i> Clear</button>
          </div>
          <div class="video-list" id="videoList"></div>
        </div>

        <!-- Favourite -->
        <div id="savedView" style="display:none">
          <div class="empty"><i class="ti ti-heart"></i><h3>No favourite wallpapers</h3><p>Heart any wallpaper to save it here.</p></div>
        </div>

      </div>

      <!-- Preview Panel -->
      <div class="preview-panel" id="previewPanel">
        <div class="pv-inner">
          <div class="pv-header">
            <h2 id="pvTitle">—</h2>
            <button class="pv-close" onclick="closePreview()"><i class="ti ti-x"></i></button>
          </div>
          <div class="pv-thumb" id="pvThumb">
            <canvas id="pvCanvas" width="580" height="326"></canvas>
            <div class="pv-play"><i class="ti ti-player-play"></i></div>
          </div>
          <div class="pv-body">
            <div class="pv-title" id="pvTitleBody">—</div>
            <div class="pv-meta" id="pvMeta"></div>
            <div class="slabel">Tags</div>
            <div class="pv-tags" id="pvTags"></div>
            <div class="pv-actions" id="pvActions"></div>
            <div class="slabel">Details</div>
            <div id="pvDetails"></div>
          </div>
        </div>
      </div>
    </div>
  </div>
</div>

<!-- Music Bar -->
<div class="music-bar" id="musicBar">
  <button class="mc" onclick="pickMusic()" title="Add Music" style="flex-shrink:0;margin-right:2px"><i class="ti ti-folder-plus"></i></button>
  <div class="music-art" id="musicArt"><i class="ti ti-music"></i></div>
  <div class="music-info">
    <div class="music-title" id="musicTitle">No track loaded</div>
    <div class="music-artist" id="musicArtist">—</div>
  </div>
  <div class="music-controls">
    <button class="mc" id="btnShuffle" onclick="toggleShuffle()" title="Shuffle"><i class="ti ti-arrows-shuffle"></i></button>
    <button class="mc" onclick="prevTrack()"><i class="ti ti-player-skip-back"></i></button>
    <button class="mc play" id="btnPlay" onclick="togglePlay()"><i class="ti ti-player-play" id="playIcon"></i></button>
    <button class="mc" onclick="nextTrack()"><i class="ti ti-player-skip-forward"></i></button>
    <button class="mc" id="btnRepeat" onclick="toggleRepeat()" title="Repeat"><i class="ti ti-repeat"></i></button>
  </div>
  <div class="music-prog">
    <div class="pbar" onclick="seekTo(event)"><div class="pfill" id="progFill" style="width:0%"></div></div>
    <div class="ptimes"><span id="timeEl">0:00</span><span id="timeDur">0:00</span></div>
  </div>
  <div class="music-vol">
    <i class="ti ti-volume" id="volIcon" onclick="toggleMute()"></i>
    <input type="range" class="vslider" id="volSlider" min="0" max="100" value="80" oninput="setVol(this.value)">
  </div>
</div>

<!-- Paywall Modal -->
<div class="overlay" id="paywallModal">
  <div class="pw-box">
    <button class="pw-close-btn" onclick="closePaywall()"><i class="ti ti-x"></i></button>
    <div class="pw-hero">
      <div class="pw-icon"><i class="ti ti-crown"></i></div>
      <div class="pw-title">Live Wallpaper Pro</div>
      <div class="pw-subtitle">Unlock the full live wallpaper experience on your Mac</div>
    </div>
    <div class="pw-body">
      <div class="pw-price">
        <span class="amount" id="pwPrice">$4.99</span><span class="per"> / month</span>
        <div class="trial" id="pwTrial">✓ 7-day free trial — cancel anytime</div>
      </div>
      <div class="pw-features">
        <div class="pw-feat"><i class="ti ti-check"></i><span>All animated wallpapers (Shader, HTML, Particles)</span></div>
        <div class="pw-feat"><i class="ti ti-check"></i><span>Upload your own MP4/MOV video wallpapers</span></div>
        <div class="pw-feat"><i class="ti ti-check"></i><span>Scan folders — find all videos automatically</span></div>
        <div class="pw-feat"><i class="ti ti-check"></i><span>Built-in music player with playlist support</span></div>
        <div class="pw-feat"><i class="ti ti-check"></i><span>Multi-monitor support</span></div>
        <div class="pw-feat"><i class="ti ti-check"></i><span>Low CPU / battery-aware rendering</span></div>
      </div>
      <button class="pw-cta" onclick="startCheckout()">Start Free Trial</button>
      <div class="pw-links">
        <a onclick="restorePurchase()">Restore Purchase</a>
        <a onclick="openPortal()">Manage Subscription</a>
        <a onclick="closePaywall()">Maybe Later</a>
      </div>
    </div>
  </div>
</div>

<!-- Upload Modal -->
<div class="modal-overlay" id="uploadModal">
  <div class="mbox">
    <div class="mhdr"><span class="mtitle">Upload Video Wallpaper</span><button class="mclose" onclick="closeUploadModal()"><i class="ti ti-x"></i></button></div>
    <div class="dropzone" id="dropZone" onclick="triggerUpload()">
      <i class="ti ti-cloud-upload" id="dropIcon"></i>
      <p id="dropText"><strong>Click to choose a video file</strong><br>MP4, MOV, M4V</p>
      <div class="fname" id="fname"></div>
    </div>
    <div class="fcol">
      <div class="fg"><label class="flabel">Title</label><input class="fi" type="text" id="upTitle" placeholder="Wallpaper name…"></div>
      <div class="frow">
        <div class="fg"><label class="flabel">Category</label>
          <select class="fs" id="upCat"><option>Abstract</option><option>Anime</option><option>Gaming</option><option>Nature</option><option>Sci-Fi</option><option>Fantasy</option><option>Minimal</option><option>Other</option></select>
        </div>
        <div class="fg"><label class="flabel">Resolution</label>
          <select class="fs" id="upRes"><option>HD 1080p</option><option>QHD 1440p</option><option>4K</option><option>5K+</option></select>
        </div>
      </div>
      <div class="fg"><label class="flabel">Tags</label><input class="fi" type="text" id="upTags" placeholder="dark, neon, lofi…"></div>
      <button class="sbtn" id="submitBtn" disabled onclick="submitUpload()">Choose a video file first</button>
    </div>
  </div>
</div>

<!-- Settings Modal -->
<div class="settings-overlay" id="settingsModal">
  <div class="settings-box">
    <div class="settings-hdr">
      <h2><i class="ti ti-settings"></i> Settings</h2>
      <button class="settings-close" onclick="closeSettings()"><i class="ti ti-x"></i></button>
    </div>
    <div class="settings-body">
      <div class="settings-section-label">UI Theme</div>
      <div class="theme-selector-group">
        <button class="theme-btn" id="theme-nebula" onclick="setAppTheme('nebula')">
          <span class="theme-dot" style="background:linear-gradient(135deg,#0088ff,#00e5ff)"></span>
          <span>Nebula</span>
        </button>
        <button class="theme-btn" id="theme-aurora" onclick="setAppTheme('aurora')">
          <span class="theme-dot" style="background:linear-gradient(135deg,#10b981,#00ffc4)"></span>
          <span>Aurora</span>
        </button>
        <button class="theme-btn" id="theme-sunset" onclick="setAppTheme('sunset')">
          <span class="theme-dot" style="background:linear-gradient(135deg,#f43f5e,#ff7e40)"></span>
          <span>Sunset</span>
        </button>
        <button class="theme-btn" id="theme-forest" onclick="setAppTheme('forest')">
          <span class="theme-dot" style="background:linear-gradient(135deg,#10b981,#34d399)"></span>
          <span>Forest</span>
        </button>
        <button class="theme-btn" id="theme-sakura" onclick="setAppTheme('sakura')">
          <span class="theme-dot" style="background:linear-gradient(135deg,#ec4899,#f472b6)"></span>
          <span>Sakura</span>
        </button>
        <button class="theme-btn" id="theme-frost" onclick="setAppTheme('frost')">
          <span class="theme-dot" style="background:linear-gradient(135deg,#3b82f6,#93c5fd)"></span>
          <span>Frost</span>
        </button>
        <button class="theme-btn" id="theme-solar" onclick="setAppTheme('solar')">
          <span class="theme-dot" style="background:linear-gradient(135deg,#f59e0b,#fbbf24)"></span>
          <span>Solar</span>
        </button>
        <button class="theme-btn" id="theme-amethyst" onclick="setAppTheme('amethyst')">
          <span class="theme-dot" style="background:linear-gradient(135deg,#8b5cf6,#a78bfa)"></span>
          <span>Amethyst</span>
        </button>
        <button class="theme-btn" id="theme-light" onclick="setAppTheme('light')">
          <span class="theme-dot" style="background:linear-gradient(135deg,#e2e8f0,#94a3b8)"></span>
          <span>Light</span>
        </button>
      </div>
      <div class="settings-section-label">Interface Transparency</div>
      <div class="settings-row" style="cursor:default">
        <i class="ti ti-adjustments-horizontal"></i>
        <div class="settings-row-text" style="display:flex;align-items:center;gap:12px;width:100%">
          <div class="settings-row-title" style="min-width:70px">Glass Opacity</div>
          <input type="range" min="10" max="95" value="45" id="transparencySlider" class="vslider" style="flex:1;accent-color:var(--accent)" oninput="setAppTransparency(this.value)">
          <span id="transparencyValue" style="font-size:11px;font-family:monospace;width:28px">45%</span>
        </div>
      </div>
      <div class="settings-section-label">Custom Background Image</div>
      <div class="settings-row" onclick="triggerBgImageUpload()">
        <i class="ti ti-photo-plus"></i>
        <div class="settings-row-text">
          <div class="settings-row-title">Upload Background Image</div>
          <div class="settings-row-sub" id="bgImageNameLabel">No image uploaded</div>
        </div>
      </div>
      <input type="file" id="bgImageInput" accept="image/*" style="display:none" onchange="handleBgImageUpload(this)">
      <div class="settings-row" id="bgImageOpacityRow" style="display:none;cursor:default">
        <i class="ti ti-opacity"></i>
        <div class="settings-row-text" style="display:flex;align-items:center;gap:12px;width:100%">
          <div class="settings-row-title" style="min-width:70px">Image Opacity</div>
          <input type="range" min="0" max="100" value="30" id="bgImageOpacitySlider" class="vslider" style="flex:1;accent-color:var(--accent)" oninput="setBgImageOpacity(this.value)">
          <span id="bgImageOpacityValue" style="font-size:11px;font-family:monospace;width:28px">30%</span>
        </div>
      </div>
      <button class="btn btn-ghost" id="clearBgImageBtn" style="display:none;color:var(--red);margin-top:4px;width:100%;justify-content:center" onclick="clearBgImage()"><i class="ti ti-trash"></i> Remove Background Image</button>
      <div class="settings-section-label">Downloads</div>
      <div class="settings-row" onclick="openDownloadDirPicker()">
        <i class="ti ti-folder"></i>
        <div class="settings-row-text">
          <div class="settings-row-title">Download Location</div>
          <div class="settings-row-sub" id="dlDirLabel">~/Downloads (default)</div>
        </div>
        <i class="ti ti-chevron-right arrow"></i>
      </div>
      <div class="settings-section-label">General</div>
      <div class="settings-row" onclick="settingsClearCache()">
        <i class="ti ti-trash-x"></i>
        <div class="settings-row-text">
          <div class="settings-row-title">Clear App Cache</div>
          <div class="settings-row-sub">Clears WebView cache and temp files</div>
        </div>
        <i class="ti ti-chevron-right arrow"></i>
      </div>
      <div class="settings-section-label">Library</div>
      <div class="settings-row danger" onclick="settingsClearUploads()">
        <i class="ti ti-cloud-off"></i>
        <div class="settings-row-text">
          <div class="settings-row-title">Clear Video Collection Library</div>
          <div class="settings-row-sub">Removes all items — original files kept</div>
        </div>
        <i class="ti ti-chevron-right arrow"></i>
      </div>
      <div class="settings-row danger" onclick="settingsClearLocalVideos()">
        <i class="ti ti-folder-off"></i>
        <div class="settings-row-text">
          <div class="settings-row-title">Clear Local Videos</div>
          <div class="settings-row-sub">Removes scanned entries — files kept on disk</div>
        </div>
        <i class="ti ti-chevron-right arrow"></i>
      </div>
    </div>
  </div>
</div>

<div class="toast" id="toast"></div>
<audio id="audioEl" preload="metadata"></audio>

<script>
// ── Preset data ───────────────────────────────────────────────────────────────
const PRESET = [
  {id:0,title:"Aurora Cascade",cat:"Abstract",wtype:"shader",views:"14.2k",likes:"892",dur:"0:24",badge:"new",tags:["abstract","purple","dark"],res:"4K",fmt:"Standard",colors:["#1a0a3a","#7c5cfc","#c084fc","#0d0020"]},
  {id:1,title:"Neon Cityscape",cat:"Sci-Fi",wtype:"shader",views:"31.5k",likes:"2.1k",dur:"0:18",badge:"trending",tags:["neon","city","sci-fi"],res:"4K",fmt:"Ultrawide",colors:["#05060f","#0e1a3f","#1e3a8a","#3b82f6"]},
  {id:2,title:"Forest Spirits",cat:"Nature",wtype:"html",views:"8.9k",likes:"441",dur:"0:32",badge:"",tags:["fantasy","green","nature"],res:"QHD",fmt:"Standard",colors:["#0a1a0a","#14532d","#166534","#4ade80"]},
  {id:3,title:"Mecha Rain",cat:"Anime",wtype:"html",views:"55.1k",likes:"3.8k",dur:"0:15",badge:"trending",tags:["anime","rain","dark"],res:"4K",fmt:"Standard",colors:["#0f0f1a","#1c1c2e","#4338ca","#818cf8"]},
  {id:4,title:"Void Bloom",cat:"Abstract",wtype:"particles",views:"22.4k",likes:"1.5k",dur:"0:28",badge:"",tags:["abstract","dark","particles"],res:"5K+",fmt:"Standard",colors:["#050008","#3b0764","#7e22ce","#d8b4fe"]},
  {id:5,title:"Desert Dunes",cat:"Nature",wtype:"shader",views:"6.3k",likes:"318",dur:"0:45",badge:"new",tags:["nature","warm","desert"],res:"HD",fmt:"Standard",colors:["#1a0e00","#78350f","#b45309","#fbbf24"]},
  {id:6,title:"Circuit Dreams",cat:"Gaming",wtype:"particles",views:"18.7k",likes:"1.2k",dur:"0:20",badge:"",tags:["gaming","neon","tech"],res:"4K",fmt:"Standard",colors:["#011208","#052e16","#16a34a","#4ade80"]},
  {id:7,title:"Ethereal Tides",cat:"Abstract",wtype:"html",views:"9.1k",likes:"603",dur:"0:35",badge:"",tags:["abstract","blue","water"],res:"QHD",fmt:"Ultrawide",colors:["#00040f","#0c2a4a","#0369a1","#38bdf8"]},
  {id:8,title:"Sakura Loop",cat:"Anime",wtype:"particles",views:"41.2k",likes:"3.1k",dur:"0:22",badge:"trending",tags:["anime","pink","sakura"],res:"4K",fmt:"Standard",colors:["#1a020e","#4c0519","#9f1239","#fb7185"]},
  {id:9,title:"Glacial Drift",cat:"Abstract",wtype:"shader",views:"5.2k",likes:"287",dur:"0:40",badge:"new",tags:["minimal","blue","cold"],res:"5K+",fmt:"Standard",colors:["#030c15","#0c2340","#1a4568","#90cdf4"]},
  {id:10,title:"Lava Pulse",cat:"Abstract",wtype:"shader",views:"27.8k",likes:"2.4k",dur:"0:19",badge:"trending",tags:["abstract","red","fire"],res:"4K",fmt:"Standard",colors:["#1a0000","#7f1d1d","#dc2626","#fca5a5"]},
  {id:11,title:"Deep Space",cat:"Sci-Fi",wtype:"particles",views:"33.6k",likes:"2.8k",dur:"0:30",badge:"",tags:["sci-fi","space","dark"],res:"4K",fmt:"Standard",colors:["#010108","#0f0c29","#302b63","#24243e"]},
  // ── 5 default particle presets ──
  {id:12,title:"Galaxy Drift",cat:"Abstract",wtype:"particles",views:"28.4k",likes:"1.9k",dur:"∞",badge:"new",tags:["particles","galaxy","dark"],res:"4K",fmt:"Standard",colors:["#020008","#0d0130","#2e0578","#7c3aed"],isDefault:true,defaultLabel:"Particles"},
  {id:13,title:"Fireflies",cat:"Nature",wtype:"particles",views:"19.7k",likes:"1.3k",dur:"∞",badge:"",tags:["particles","green","nature"],res:"4K",fmt:"Standard",colors:["#010a02","#052e0c","#14532d","#4ade80"],isDefault:true,defaultLabel:"Particles"},
  {id:14,title:"Ember Storm",cat:"Abstract",wtype:"particles",views:"41.0k",likes:"3.2k",dur:"∞",badge:"trending",tags:["particles","fire","red"],res:"4K",fmt:"Standard",colors:["#1a0000","#450a0a","#b91c1c","#fca5a5"],isDefault:true,defaultLabel:"Particles"},
  {id:15,title:"Snowfall",cat:"Minimal",wtype:"particles",views:"12.1k",likes:"876",dur:"∞",badge:"",tags:["particles","snow","minimal"],res:"4K",fmt:"Standard",colors:["#04060f","#0c1a3a","#1e3a6e","#bfdbfe"],isDefault:true,defaultLabel:"Particles"},
  {id:16,title:"Neon Rain",cat:"Gaming",wtype:"particles",views:"55.3k",likes:"4.1k",dur:"∞",badge:"trending",tags:["particles","neon","rain"],res:"4K",fmt:"Standard",colors:["#000a0f","#002030","#004060","#00d4ff"],isDefault:true,defaultLabel:"Particles"},
];


// ── State — uploads come from Swift/UploadManager, NOT local JS ──────────────
let userUploads   = [];   // populated by onUploadsChanged() called from Swift
let scannedVideos = [];
let currentView   = 'browse';
let selectedCard  = null;
let searchQuery   = '';
let activeTabCat  = 'All';
let subState      = { subscribed:false, trial:true, trialDays:7, price:'$4.99' };

// Pending single-file upload (shown in modal before saving)
let pendingFile = null;   // {name, path}

// Favourites & Dragging Custom Helpers
function getFavourites() {
  try {
    return JSON.parse(localStorage.getItem('favourites') || '[]');
  } catch (e) {
    return [];
  }
}
function saveFavourites(favs) {
  localStorage.setItem('favourites', JSON.stringify(favs));
}
function isFavourite(id) {
  return getFavourites().some(f => String(f.id) === String(id));
}

// UI Themes Switching, Transparency & Dashboard Stats
function setAppTransparency(val) {
  const opacity = val / 100;
  document.documentElement.style.setProperty('--glass-opacity', opacity);
  const valEl = document.getElementById('transparencyValue');
  if (valEl) valEl.textContent = val + '%';
  localStorage.setItem('selected-transparency', val);
}
function loadSavedTransparency() {
  const saved = localStorage.getItem('selected-transparency') || '45';
  const slider = document.getElementById('transparencySlider');
  if (slider) slider.value = saved;
  setAppTransparency(saved);
}
// App Custom Backgrounds Switcher
function setAppBg(bgName) {
  document.body.classList.remove('bg-default', 'bg-cosmic', 'bg-aurora', 'bg-cyber');
  document.body.classList.add('bg-' + bgName);
  document.querySelectorAll('.bg-btn').forEach(btn => {
    btn.classList.toggle('active', btn.id === 'bg-' + bgName);
  });
  localStorage.setItem('selected-bg', bgName);
}
function loadSavedBg() {
  const saved = localStorage.getItem('selected-bg') || 'default';
  setAppBg(saved);
}

// Background Image Upload & Opacity custom logic
function triggerBgImageUpload() {
  if (window.webkit && window.webkit.messageHandlers && window.webkit.messageHandlers.pickBgImage) {
    window.webkit.messageHandlers.pickBgImage.postMessage({});
  } else {
    document.getElementById('bgImageInput').click();
  }
}
function onBgImagePicked(path, name) {
  setCustomBgImage(path, name);
  showToast('✓ Background image set!');
}
function handleBgImageUpload(input) {
  const file = input.files[0];
  if (!file) return;
  showToast('Processing background image...');
  const reader = new FileReader();
  reader.onload = function(e) {
    const dataUrl = e.target.result;
    const img = new Image();
    img.onload = function() {
      const maxDim = 1440;
      let w = img.width;
      let h = img.height;
      if (w > maxDim || h > maxDim) {
        if (w > h) {
          h = Math.round((h * maxDim) / w);
          w = maxDim;
        } else {
          w = Math.round((w * maxDim) / h);
          h = maxDim;
        }
        const canvas = document.createElement('canvas');
        canvas.width = w;
        canvas.height = h;
        const ctx = canvas.getContext('2d');
        ctx.drawImage(img, 0, 0, w, h);
        const compressed = canvas.toDataURL('image/jpeg', 0.8);
        setCustomBgImage(compressed, file.name);
      } else {
        setCustomBgImage(dataUrl, file.name);
      }
      showToast('✓ Background image set!');
    };
    img.src = dataUrl;
  };
  reader.readAsDataURL(file);
}
function setCustomBgImage(dataUrl, filename) {
  const el = document.getElementById('customBgImage');
  if (el) {
    el.style.backgroundImage = `url(${dataUrl})`;
    el.style.display = 'block';
  }
  const label = document.getElementById('bgImageNameLabel');
  if (label) label.textContent = filename || 'Custom Image';
  document.getElementById('bgImageOpacityRow').style.display = 'flex';
  document.getElementById('clearBgImageBtn').style.display = 'inline-flex';
  localStorage.setItem('custom-bg-image', dataUrl);
  localStorage.setItem('custom-bg-image-name', filename || 'Custom Image');
}
function setBgImageOpacity(val) {
  const opacity = val / 100;
  document.documentElement.style.setProperty('--bg-image-opacity', opacity);
  const valEl = document.getElementById('bgImageOpacityValue');
  if (valEl) valEl.textContent = val + '%';
  localStorage.setItem('custom-bg-image-opacity', val);
}
function clearBgImage() {
  const el = document.getElementById('customBgImage');
  if (el) {
    el.style.backgroundImage = '';
    el.style.display = 'none';
  }
  const label = document.getElementById('bgImageNameLabel');
  if (label) label.textContent = 'No image uploaded';
  document.getElementById('bgImageOpacityRow').style.display = 'none';
  document.getElementById('clearBgImageBtn').style.display = 'none';
  document.getElementById('bgImageInput').value = '';
  localStorage.removeItem('custom-bg-image');
  localStorage.removeItem('custom-bg-image-name');
  showToast('Background image removed');
}
function loadSavedBgImage() {
  const savedUrl = localStorage.getItem('custom-bg-image');
  const savedName = localStorage.getItem('custom-bg-image-name');
  const savedOpacity = localStorage.getItem('custom-bg-image-opacity') || '30';
  if (savedUrl) {
    setCustomBgImage(savedUrl, savedName);
    const slider = document.getElementById('bgImageOpacitySlider');
    if (slider) slider.value = savedOpacity;
    setBgImageOpacity(savedOpacity);
  }
}
function setAppTheme(themeName) {
  // Safe theme class toggle without wiping background/other classes
  document.body.classList.forEach(cls => {
    if (cls.startsWith('theme-')) {
      document.body.classList.remove(cls);
    }
  });
  document.body.classList.add('theme-' + themeName);
  
  // Highlight active button in settings
  document.querySelectorAll('.theme-btn').forEach(btn => {
    btn.classList.toggle('active', btn.id === 'theme-' + themeName);
  });
  
  localStorage.setItem('selected-theme', themeName);
}
function loadSavedTheme() {
  const saved = localStorage.getItem('selected-theme') || 'nebula';
  setAppTheme(saved);
}
function updateDashboardStats() {
  const hsAll = document.getElementById('hsAll');
  if (hsAll) hsAll.textContent = PRESET.length + userUploads.length;
  
  const hsCollection = document.getElementById('hsCollection');
  if (hsCollection) hsCollection.textContent = userUploads.length;
  
  const hsLocal = document.getElementById('hsLocal');
  if (hsLocal) hsLocal.textContent = scannedVideos.length;
  
  const hsFav = document.getElementById('hsFav');
  if (hsFav) hsFav.textContent = getFavourites().length;
}
function findWallpaperById(id) {
  let item = PRESET.find(p => String(p.id) === String(id));
  if (!item) {
    item = userUploads.find(u => String(u.id) === String(id));
  }
  if (!item) {
    item = scannedVideos.find(v => String(v.id) === String(id));
  }
  if (!item) {
    item = getFavourites().find(f => String(f.id) === String(id));
  }
  return item;
}
function toggleFavouriteById(id, isUpload) {
  const item = findWallpaperById(id);
  if (!item) return;
  let favs = getFavourites();
  const index = favs.findIndex(f => String(f.id) === String(id));
  if (index >= 0) {
    favs.splice(index, 1);
    saveFavourites(favs);
    showToast('♥ Removed from Favourites');
  } else {
    favs.push({ ...item, isUpload: !!isUpload });
    saveFavourites(favs);
    showToast('♥ Saved to Favourites');
  }
  rerenderActive();
  if (selectedCard && String(selectedCard.id) === String(id)) {
    if (currentView === 'videos') {
      openScannedPreview(item);
    } else {
      openPreview(item, isUpload);
    }
  }
  if (currentView === 'saved') {
    renderFavourites();
  }
}
function renderFavourites() {
  const view = document.getElementById('savedView'); if(!view) return;
  const favs = getFavourites();
  if (!favs.length) {
    view.innerHTML = `<div class="empty"><i class="ti ti-heart"></i><h3>No favourite wallpapers</h3><p>Heart any wallpaper to save it here.</p></div>`;
    return;
  }
  view.innerHTML = `<div class="gallery" id="savedGallery"></div>`;
  const grid = document.getElementById('savedGallery');
  grid.className = 'gallery sz-' + (gallerySize || 'medium');
  favs.forEach(c => {
    const card = buildCard(c, c.isUpload);
    grid.appendChild(card);
  });
}
document.addEventListener('mousedown', function(e) {
  const dragTarget = e.target.closest('.topbar') || e.target.closest('.sidebar');
  if (dragTarget && !e.target.closest('.search-wrap, .topbar-right, .nav-item, .sub-pill, .tab, .sort-select, .size-toggle-group, button, input, select, textarea, a, [onclick]')) {
    if (window.webkit?.messageHandlers?.startWindowDrag) {
      window.webkit.messageHandlers.startWindowDrag.postMessage({});
    }
  }
});

// ── Swift-driven callbacks ────────────────────────────────────────────────────

// Called by Swift on every page load AND after any upload add/remove/clear
function onUploadsChanged(uploads) {
  if (uploads !== undefined) userUploads = uploads;
  updateUploadsBadge();
  if (currentView === 'uploads') renderUploads();
  if (currentView === 'browse') renderBrowse();
  if (selectedCard) {
    const updated = userUploads.find(u => u.id === selectedCard.id);
    if (updated) {
      selectedCard = updated;
      const editBox = document.getElementById('editTitle');
      if (!editBox) {
        openPreview(updated, true);
      }
    }
  }
}

// Called by Swift when user picked a single file — show the upload form modal
function onVideoPickerReady(files) {
  if (!files || !files.length) return;
  if (files.length === 1) {
    pendingFile = files[0];
    document.getElementById('upTitle').value = files[0].name.replace(/\\.[^.]+$/, '');
    document.getElementById('fname').textContent = files[0].name;
    document.getElementById('fname').style.display = 'block';
    document.getElementById('dropZone').className = 'dropzone has-file';
    document.getElementById('dropIcon').className = 'ti ti-circle-check';
    document.getElementById('dropText').innerHTML = '<strong>Video selected</strong>';
    document.getElementById('submitBtn').disabled = false;
    document.getElementById('submitBtn').textContent = 'Add to Video Collection';
    document.getElementById('uploadModal').classList.add('open');
  }
}

// Navigate to uploads view — called by Swift after multi-file add
function switchToUploads() {
  switchView('uploads', document.getElementById('nav-uploads'));
}

function updateUploadsBadge() {
  const el = document.getElementById('ucnt');
  if (!el) return;
  el.textContent = userUploads.length;
  el.className   = userUploads.length > 0 ? 'nbadge live' : 'nbadge';
}

// ── Canvas thumb ──────────────────────────────────────────────────────────────
function drawThumb(cv, colors, w, h) {
  cv.width=w; cv.height=h;
  const ctx=cv.getContext('2d');
  const g=ctx.createLinearGradient(0,0,w,h);
  g.addColorStop(0,colors[0]); g.addColorStop(.4,colors[1]);
  g.addColorStop(.75,colors[2]); g.addColorStop(1,colors[3]||colors[2]);
  ctx.fillStyle=g; ctx.fillRect(0,0,w,h);
  for(let i=0;i<12;i++){
    const x=Math.random()*w,y=Math.random()*h,r=Math.random()*36+7;
    const g2=ctx.createRadialGradient(x,y,0,x,y,r);
    g2.addColorStop(0,colors[2]+'55'); g2.addColorStop(1,colors[0]+'00');
    ctx.fillStyle=g2; ctx.beginPath(); ctx.arc(x,y,r,0,Math.PI*2); ctx.fill();
  }
}

// ── Gallery cards ─────────────────────────────────────────────────────────────
function buildCard(c, isUpload) {
  const div=document.createElement('div');
  div.className='card'+(selectedCard&&selectedCard.id===c.id?' selected':'');
  const badge=isUpload?'<div class="lbl lbl-mine">MINE</div>'
    :c.badge==='new'?'<div class="lbl lbl-new">NEW</div>'
    :c.badge==='trending'?'<div class="lbl lbl-trending">TRENDING</div>':'';
  const acts=`<div class="card-actions">
        <button class="cab" title="Save" onclick="event.stopPropagation();toggleFavouriteById('${c.id}', ${!!isUpload})">
          <i class="ti ${isFavourite(c.id) ? 'ti-heart-filled' : 'ti-heart'}" style="${isFavourite(c.id) ? 'color:var(--red)' : ''}"></i>
        </button>
        ${isUpload ? `<button class="cab del" title="Delete" onclick="event.stopPropagation();deleteUpload('${c.id}')"><i class="ti ti-trash"></i></button>` : ''}
      </div>`;
  const vpath = c.fileURL || c.videoPath || '';
  const media = (isUpload && vpath)
    ? (c.thumbnail
        ? `<img src="data:image/jpeg;base64,${c.thumbnail}" style="width:100%;height:100%;object-fit:cover;display:block">`
        : `<video src="${vpath.replace('file://', 'local-file://')}" muted loop playsinline preload="metadata"></video>`)
    : `<canvas id="cv-${c.id}" width="320" height="180"></canvas>`;
  div.innerHTML=`<div class="thumb">${media}<div class="dur">${c.dur||'—'}</div>${badge}${acts}</div>
    <div class="card-info"><div class="card-title">${c.title}</div>
    <div class="card-meta">
      <span class="cstat"><i class="ti ti-eye"></i>${c.views||'0'}</span>
      <span class="cstat"><i class="ti ti-heart"></i>${c.likes||'0'}</span>
      <span class="ccat">${c.cat||c.category||'Video'}</span>
    </div>
    <div class="card-tags">${(c.tags||[]).map(t=>`<span class="ctag">${t}</span>`).join('')}</div></div>`;
  div.addEventListener('click',()=>openPreview(c,isUpload));
  return div;
}

function filtered(list){
  return list.filter(c=>{
    const mc=activeTabCat==='All'||c.cat===activeTabCat||(c.tags||[]).includes(activeTabCat.toLowerCase());
    const ms=!searchQuery||c.title.toLowerCase().includes(searchQuery)||(c.tags||[]).some(t=>t.includes(searchQuery));
    return mc&&ms;
  });
}

function renderBrowse(){
  const grid=document.getElementById('browseGallery'); grid.innerHTML='';
  grid.className='gallery sz-'+(gallerySize||'medium');
  
  // Combine custom uploads with presets
  const mappedUploads = userUploads.map(u => ({
    id: u.id,
    title: u.title,
    cat: u.cat || u.category || 'Other',
    wtype: 'video',
    views: u.views || '0',
    likes: u.likes || '0',
    dur: u.dur || u.duration || '—',
    badge: 'mine',
    tags: u.tags || [],
    res: u.res || u.resolution || '—',
    colors: u.colors || ['#0a0a0f', '#1a1a24', '#2a2a3a', '#7c5cfc'],
    fileURL: u.fileURL,
    isUpload: true,
    thumbnail: u.thumbnail
  }));
  
  let list = mappedUploads.concat(PRESET);
  if(currentView==='trending') list=list.filter(c=>c.badge==='trending');
  if(currentView==='new')      list=list.filter(c=>c.badge==='new');
  filtered(list).forEach(c=>{
    const card=buildCard(c, c.isUpload); grid.appendChild(card);
    if (!c.isUpload) {
      requestAnimationFrame(()=>{ const cv=document.getElementById(`cv-${c.id}`); if(cv) drawThumb(cv,c.colors,320,180); });
    }
  });
}

function renderUploads(){
  const grid=document.getElementById('uploadsGallery'); grid.innerHTML='';
  grid.className='gallery sz-'+(gallerySize||'medium');
  document.getElementById('uploadsSub').textContent = userUploads.length
    ? `${userUploads.length} video${userUploads.length!==1?'s':''} — click to preview or apply`
    : 'Your uploaded videos appear here';

  if(!userUploads.length){
    grid.innerHTML=`<div class="empty" style="grid-column:1/-1">
      <i class="ti ti-video-off"></i><h3>No uploads yet</h3>
      <p>Click "Upload" to add MP4 or MOV files as wallpapers.</p>
      <button class="btn btn-primary" style="margin-top:10px" onclick="triggerUpload()">
        <i class="ti ti-upload"></i> Upload Video
      </button>
    </div>`;
    return;
  }

  userUploads.forEach(c=>{
    const vpath = c.fileURL || c.videoPath || '';
    const card  = buildCard({...c, videoPath: vpath}, true);
    grid.appendChild(card);
  });
}

// ── Local Videos (folder scan) ─────────────────────────────────────────────────────
function renderScannedVideos(){
  const list=document.getElementById('videoList'); if(!list) return;
  list.innerHTML='';
  const cnt=document.getElementById('vcnt');
  cnt.textContent=scannedVideos.length;
  cnt.className=scannedVideos.length>0?'nbadge live':'nbadge';
  document.getElementById('vtCount').textContent=`${scannedVideos.length} video${scannedVideos.length!==1?'s':''}`;
  document.getElementById('videosToolbar').style.display=scannedVideos.length?'flex':'none';
  if(!scannedVideos.length){
    list.innerHTML=`<div class="empty"><i class="ti ti-folder-off"></i><h3>No videos found</h3><p>Click "Scan Folder" to find video files on your Mac.</p></div>`;
    return;
  }
  const q=searchQuery;
  scannedVideos.filter(v=>!q||v.title.toLowerCase().includes(q)||v.fileName.toLowerCase().includes(q)).forEach(v=>{
    const row=document.createElement('div');
    row.className='video-row'+(selectedCard&&selectedCard.id===v.id?' selected':'');
    const media = v.thumbnail
      ? `<img src="data:image/jpeg;base64,${v.thumbnail}" style="width:100%;height:100%;object-fit:cover;display:block">`
      : `<canvas id="svcv-${v.id}" width="128" height="72"></canvas>`;
    row.innerHTML=`
      <div class="vr-thumb">${media}</div>
      <div class="vr-info">
        <div class="vr-title">${v.title}</div>
        <div class="vr-meta">
          <span><i class="ti ti-clock"></i>${v.duration}</span>
          <span><i class="ti ti-device-desktop"></i>${v.res}</span>
          <span><i class="ti ti-database"></i>${v.size}</span>
        </div>
      </div>
      <div class="vr-actions">
        <button class="cab" title="Favourite" onclick="event.stopPropagation();toggleFavouriteById('${v.id}', true)">
          <i class="ti ${isFavourite(v.id) ? 'ti-heart-filled' : 'ti-heart'}" style="${isFavourite(v.id) ? 'color:var(--red)' : ''}"></i>
        </button>
        <button class="cab" title="Apply" onclick="event.stopPropagation();applyScanned('${v.fileURL}')"><i class="ti ti-device-desktop"></i></button>
        <button class="cab del" title="Remove" onclick="event.stopPropagation();removeScanned('${v.id}')"><i class="ti ti-x"></i></button>
      </div>`;
    row.addEventListener('click',()=>openScannedPreview(v));
    list.appendChild(row);
    if (!v.thumbnail) {
      requestAnimationFrame(()=>{ const cv=document.getElementById(`svcv-${v.id}`); if(cv) drawThumb(cv,['#0a0a0f','#1a1a24','#22222f','#383850'],128,72); });
    }
  });
}

// ── Preview panel ─────────────────────────────────────────────────────────────
function openPreview(c, isUpload){
  selectedCard=c; stopPvVideo();
  document.getElementById('pvTitle').textContent=c.title;
  document.getElementById('pvTitleBody').textContent=c.title;
  const vpath = c.fileURL || c.videoPath || '';
  document.getElementById('pvMeta').innerHTML=`
    <span><i class="ti ti-eye"></i>${c.views||'0'}</span>
    <span><i class="ti ti-heart"></i>${c.likes||'0'}</span>
    <span><i class="ti ti-clock"></i>${c.dur||c.duration||'—'}</span>`;
  document.getElementById('pvTags').innerHTML=(c.tags||[]).map(t=>`<span class="pv-tag">${t}</span>`).join('');
  const pvThumb=document.getElementById('pvThumb');
  if(isUpload && vpath){
    pvThumb.innerHTML=`<video id="pvVideo" src="${vpath.replace('file://', 'local-file://')}" muted loop playsinline style="width:100%;height:100%;object-fit:cover;cursor:pointer" onclick="togglePvVideo()"></video>
      <div class="pv-play" onclick="togglePvVideo()"><i class="ti ti-player-play" id="pvPlayIcon"></i></div>`;
  } else {
    pvThumb.innerHTML=`<canvas id="pvCanvas" width="580" height="326"></canvas><div class="pv-play"><i class="ti ti-player-play"></i></div>`;
    requestAnimationFrame(()=>{ const cv=document.getElementById('pvCanvas'); if(cv) drawThumb(cv,c.colors||['#0a0a0f','#1a1a24','#2a2a3a','#7c5cfc'],580,326); });
  }
  document.getElementById('pvActions').innerHTML=isUpload
    ?`<button class="pvbtn pvbtn-apply" data-wtype="video" data-vpath="${vpath}" onclick="applyWallpaper(this)"><i class="ti ti-device-desktop"></i> Apply as Wallpaper</button>
       <div style="display:flex;gap:6px">
         <button class="pvbtn pvbtn-sec" onclick="toggleFavouriteById('${c.id}', true)" style="flex:1">
           <i class="ti ${isFavourite(c.id) ? 'ti-heart-filled' : 'ti-heart'}" style="${isFavourite(c.id) ? 'color:var(--red)' : ''}"></i>
           ${isFavourite(c.id) ? 'Favourited' : 'Favourite'}
         </button>
         <button class="pvbtn pvbtn-sec" onclick="editUploadInfo('${c.id}')" style="flex:1"><i class="ti ti-edit"></i> Edit Info</button>
       </div>
       <button class="pvbtn pvbtn-del" onclick="deleteUpload('${c.id}');closePreview()"><i class="ti ti-trash"></i> Delete from Library</button>`
    :`<button class="pvbtn pvbtn-apply" data-wtype="${c.wtype}" data-vpath="" onclick="applyWallpaper(this)"><i class="ti ti-device-desktop"></i> Apply as Wallpaper</button>
       <button class="pvbtn pvbtn-sec" onclick="toggleFavouriteById('${c.id}', ${!!isUpload})">
         <i class="ti ${isFavourite(c.id) ? 'ti-heart-filled' : 'ti-heart'}" style="${isFavourite(c.id) ? 'color:var(--red)' : ''}"></i>
         ${isFavourite(c.id) ? 'Favourited' : 'Favourite'}
       </button>`;
  document.getElementById('pvDetails').innerHTML=`
    <div class="pv-row"><span class="l2">Category</span><span class="v2">${c.cat||c.category||'Video'}</span></div>
    <div class="pv-row"><span class="l2">Resolution</span><span class="v2">${c.res||c.resolution||'—'}</span></div>
    ${isUpload&&c.fileName?`<div class="pv-row"><span class="l2">File</span><span class="v2">${c.fileName}</span></div>`:''}`;
  document.getElementById('previewPanel').classList.add('open');
  rerenderActive();
}

function openScannedPreview(v){
  selectedCard=v; stopPvVideo();
  document.getElementById('pvTitle').textContent=v.title;
  document.getElementById('pvTitleBody').textContent=v.title;
  document.getElementById('pvMeta').innerHTML=`
    <span><i class="ti ti-clock"></i>${v.duration}</span>
    <span><i class="ti ti-device-desktop"></i>${v.res}</span>
    <span><i class="ti ti-database"></i>${v.size}</span>`;
  document.getElementById('pvTags').innerHTML=`<span class="pv-tag">video</span><span class="pv-tag">local</span>`;
  
  // Use HTML5 video with poster thumbnail for instant local video playback
  document.getElementById('pvThumb').innerHTML=`
    <video id="pvVideo" src="${v.fileURL.replace('file://', 'local-file://')}" muted loop playsinline style="width:100%;height:100%;object-fit:cover;cursor:pointer" poster="data:image/jpeg;base64,${v.thumbnail || ''}" onclick="togglePvVideo()"></video>
    <div class="pv-play" onclick="togglePvVideo()"><i class="ti ti-player-play" id="pvPlayIcon"></i></div>`;
  document.getElementById('pvActions').innerHTML=`
    <button class="pvbtn pvbtn-apply" data-wtype="video" data-vpath="${v.fileURL}" onclick="applyWallpaper(this)"><i class="ti ti-device-desktop"></i> Apply as Wallpaper</button>
    <div style="display:flex;gap:6px">
      <button class="pvbtn pvbtn-sec" onclick="toggleFavouriteById('${v.id}', true)" style="flex:1">
        <i class="ti ${isFavourite(v.id) ? 'ti-heart-filled' : 'ti-heart'}" style="${isFavourite(v.id) ? 'color:var(--red)' : ''}"></i>
        ${isFavourite(v.id) ? 'Favourited' : 'Favourite'}
      </button>
      <button class="pvbtn pvbtn-del" onclick="removeScanned('${v.id}');closePreview()" style="flex:1;border-color:rgba(248,113,113,.35);color:var(--red)"><i class="ti ti-x"></i> Remove</button>
    </div>`;
  document.getElementById('pvDetails').innerHTML=`
    <div class="pv-row"><span class="l2">File</span><span class="v2">${v.fileName}</span></div>
    <div class="pv-row"><span class="l2">Size</span><span class="v2">${v.size}</span></div>
    <div class="pv-row"><span class="l2">Resolution</span><span class="v2">${v.res}</span></div>`;
  document.getElementById('previewPanel').classList.add('open');
  renderScannedVideos();
}

function closePreview(){ stopPvVideo(); selectedCard=null; document.getElementById('previewPanel').classList.remove('open'); rerenderActive(); }
function stopPvVideo(){ const v=document.getElementById('pvVideo'); if(v){v.pause();v.removeAttribute('src');} }
function togglePvVideo(){ const v=document.getElementById('pvVideo'),ic=document.getElementById('pvPlayIcon'); if(!v)return; v.paused?(v.play(),ic.className='ti ti-player-pause'):(v.pause(),ic.className='ti ti-player-play'); }
function applyWallpaper(btn){ if(window.webkit?.messageHandlers?.applyWallpaper) window.webkit.messageHandlers.applyWallpaper.postMessage({type:btn.dataset.wtype,videoPath:btn.dataset.vpath}); showToast('\u{2713} Wallpaper applied!'); }
function applyScanned(url){ if(window.webkit?.messageHandlers?.applyWallpaper) window.webkit.messageHandlers.applyWallpaper.postMessage({type:'video',videoPath:url}); showToast('\u{2713} Wallpaper applied!'); }
function saveCard(){ showToast('\u{2665} Saved to library'); }

// ── Upload actions ────────────────────────────────────────────────────────────
function triggerUpload(){
  if(window.webkit?.messageHandlers?.uploadVideo)
    window.webkit.messageHandlers.uploadVideo.postMessage({});
}

// Called when user clicks Submit in the upload modal
function submitUpload(){
  if(!pendingFile) return;
  const title    = document.getElementById('upTitle').value.trim();
  const category = document.getElementById('upCat').value;
  const res      = document.getElementById('upRes').value;
  const tags     = document.getElementById('upTags').value;
  if(window.webkit?.messageHandlers?.uploadVideoWithMeta)
    window.webkit.messageHandlers.uploadVideoWithMeta.postMessage({
      path: pendingFile.path, title, category, resolution: res, tags
    });
  closeUploadModal();
  // View will auto-switch via switchToUploads() called from Swift
}

function deleteUpload(id){
  if(window.webkit?.messageHandlers?.removeUpload)
    window.webkit.messageHandlers.removeUpload.postMessage({id});
  showToast('Deleted from library');
}

function editUploadInfo(id){
  const c = userUploads.find(u => u.id === id);
  if(!c) return;
  
  document.getElementById('pvDetails').innerHTML = `
    <div style="background:var(--surface2);border:1px solid var(--border);border-radius:8px;padding:12px;margin-top:8px">
      <h4 style="font-size:12px;color:var(--text);margin-bottom:8px"><i class="ti ti-edit"></i> Edit Details</h4>
      
      <div class="fg" style="margin-bottom:8px">
        <label class="flabel" style="font-size:10px">Title</label>
        <input class="fi" type="text" id="editTitle" value="${c.title}" style="width:100%;padding:6px;border-radius:6px;border:1px solid var(--border);background:var(--surface);color:var(--text);font-size:12px;outline:none">
      </div>
      
      <div class="fg" style="margin-bottom:8px">
        <label class="flabel" style="font-size:10px">Category</label>
        <select class="fs" id="editCat" style="width:100%;padding:6px;border-radius:6px;border:1px solid var(--border);background:var(--surface);color:var(--text);font-size:12px;outline:none">
          ${['Abstract', 'Anime', 'Gaming', 'Nature', 'Sci-Fi', 'Fantasy', 'Minimal', 'Other'].map(cat => 
            `<option ${cat === (c.cat || c.category) ? 'selected' : ''}>${cat}</option>`
          ).join('')}
        </select>
      </div>

      <div class="fg" style="margin-bottom:8px">
        <label class="flabel" style="font-size:10px">Resolution</label>
        <select class="fs" id="editRes" style="width:100%;padding:6px;border-radius:6px;border:1px solid var(--border);background:var(--surface);color:var(--text);font-size:12px;outline:none">
          ${['HD 1080p', 'QHD 1440p', '4K', '5K+'].map(res => 
            `<option ${res === (c.res || c.resolution) ? 'selected' : ''}>${res}</option>`
          ).join('')}
        </select>
      </div>
      
      <div class="fg" style="margin-bottom:12px">
        <label class="flabel" style="font-size:10px">Tags (comma separated)</label>
        <input class="fi" type="text" id="editTags" value="${(c.tags || []).join(', ')}" style="width:100%;padding:6px;border-radius:6px;border:1px solid var(--border);background:var(--surface);color:var(--text);font-size:12px;outline:none">
      </div>
      
      <div style="display:flex;gap:6px">
        <button class="btn btn-primary" onclick="saveUploadMeta('${c.id}')" style="flex:1;padding:6px;font-size:12px">Save</button>
        <button class="btn btn-ghost" onclick="cancelEditUpload('${c.id}')" style="flex:1;padding:6px;font-size:12px">Cancel</button>
      </div>
    </div>
  `;
}

function saveUploadMeta(id){
  const title = document.getElementById('editTitle').value.trim();
  const category = document.getElementById('editCat').value;
  const res = document.getElementById('editRes').value;
  const tags = document.getElementById('editTags').value;
  if(window.webkit?.messageHandlers?.updateUploadMeta) {
    window.webkit.messageHandlers.updateUploadMeta.postMessage({
      id, title, category, resolution: res, tags
    });
    showToast('Info updated');
  }
}

function cancelEditUpload(id){
  const c = userUploads.find(u => u.id === id);
  if (c) openPreview(c, true);
}

function clearAllUploads(){
  if(!confirm('Remove all videos from your Video Collection?\\n(Original files are NOT deleted from disk.)')) return;
  if(window.webkit?.messageHandlers?.clearUploads)
    window.webkit.messageHandlers.clearUploads.postMessage({});
  showToast('Library cleared');
}

// ── Upload modal ──────────────────────────────────────────────────────────────
function openUploadModal(){
  if(!subState.subscribed&&!subState.trial){ showPaywall(); return; }
  triggerUpload();   // open file picker — modal shown by onVideoPickerReady
}
function closeUploadModal(){
  document.getElementById('uploadModal').classList.remove('open');
  pendingFile=null;
  document.getElementById('dropZone').className='dropzone';
  document.getElementById('dropIcon').className='ti ti-cloud-upload';
  document.getElementById('dropText').innerHTML='<strong>Click to choose a video file</strong><br>MP4, MOV, M4V';
  document.getElementById('fname').style.display='none'; document.getElementById('fname').textContent='';
  document.getElementById('upTitle').value=''; document.getElementById('upTags').value='';
  document.getElementById('submitBtn').disabled=true;
  document.getElementById('submitBtn').textContent='Choose a video file first';
}

// ── Scan ──────────────────────────────────────────────────────────────────────
function triggerScan(){
  if(!subState.subscribed&&!subState.trial){ showPaywall(); return; }
  if(window.webkit?.messageHandlers?.scanFolder) window.webkit.messageHandlers.scanFolder.postMessage({});
}
function onScanStarted(){ document.getElementById('scanProgress').style.display='block'; document.getElementById('scanBar').style.width='0%'; document.getElementById('scanLabel').textContent='Scanning…'; }
function onScanProgress(cur,total){ const pct=total>0?Math.round(cur/total*100):0; document.getElementById('scanBar').style.width=pct+'%'; document.getElementById('scanLabel').textContent=`Scanning… ${cur} of ${total}`; }
function onScanFinished(){ document.getElementById('scanProgress').style.display='none'; showToast('\u{2713} Scan complete — '+scannedVideos.length+' videos found'); }
function onScannedVideosUpdated(videos){ scannedVideos=videos||[]; document.getElementById('vcnt').textContent=scannedVideos.length; document.getElementById('vcnt').className=scannedVideos.length>0?'nbadge live':'nbadge'; if(currentView==='videos') renderScannedVideos(); }
function removeScanned(id){ if(window.webkit?.messageHandlers?.removeScannedVideo) window.webkit.messageHandlers.removeScannedVideo.postMessage({id}); }
function clearScanned(){ if(confirm('Remove all scanned videos from the list?')){if(window.webkit?.messageHandlers?.clearScannedVideos) window.webkit.messageHandlers.clearScannedVideos.postMessage({});} }

// ── Subscription ──────────────────────────────────────────────────────────────
function onSubscriptionState(state){ subState=state; const pill=document.getElementById('subPill'),pt=document.getElementById('subPillText'),ps=document.getElementById('subPillSub'); if(!pill)return; if(state.subscribed){pill.style.borderColor='rgba(52,211,153,.4)';pill.style.background='rgba(52,211,153,.08)';pill.querySelector('i').className='ti ti-crown';pill.querySelector('i').style.color='#34d399';pt.textContent='Pro Active';pt.style.color='#34d399';ps.textContent='Manage subscription';}else if(state.trial){pt.textContent='Free Trial';pt.style.color='';ps.textContent=state.trialDays+'d remaining — Upgrade';}else{pt.textContent='Upgrade to Pro';ps.textContent=state.price+' / month';} }
function showPaywall(){ document.getElementById('paywallModal').classList.add('open'); }
function closePaywall(){ document.getElementById('paywallModal').classList.remove('open'); }
function startCheckout(){ if(window.webkit?.messageHandlers?.openCheckout) window.webkit.messageHandlers.openCheckout.postMessage({}); closePaywall(); showToast('Opening Stripe Checkout…'); }
function restorePurchase(){ if(window.webkit?.messageHandlers?.restorePurchase) window.webkit.messageHandlers.restorePurchase.postMessage({}); showToast('Checking subscription…'); }
function openPortal(){ if(window.webkit?.messageHandlers?.openPortal) window.webkit.messageHandlers.openPortal.postMessage({}); closePaywall(); }

// ── Navigation ────────────────────────────────────────────────────────────────
function switchView(view,navEl){
  currentView=view;
  document.querySelectorAll('.nav-item').forEach(n=>n.classList.remove('active'));
  if(navEl) navEl.classList.add('active');
  const titles={home:'Home',browse:'All Wallpapers',online:'Browse Online',trending:'Trending',new:'New Releases',uploads:'Video Collection',videos:'Local Videos',saved:'Favourite'};
  document.getElementById('topbarTitle').textContent=titles[view]||'';
  
  // Hide search wrap in Home view
  const searchWrap = document.querySelector('.search-wrap');
  if (searchWrap) {
    searchWrap.style.visibility = view === 'home' ? 'hidden' : 'visible';
  }
  
  document.getElementById('homeView').style.display=view==='home'?'block':'none';
  const bv=['browse','trending','new'];
  document.getElementById('browseView').style.display=bv.includes(view)?'block':'none';
  document.getElementById('onlineView').style.display=view==='online'?'block':'none';
  document.getElementById('uploadsView').style.display=view==='uploads'?'block':'none';
  document.getElementById('videosView').style.display=view==='videos'?'block':'none';
  document.getElementById('savedView').style.display=view==='saved'?'block':'none';
  if(view==='saved') renderFavourites();
  if(view==='home') updateDashboardStats();
  closePreview();
  if(bv.includes(view)) renderBrowse();
  if(view==='uploads') renderUploads();
  if(view==='videos') renderScannedVideos();
  // Size toggle: show only on gallery views
  const galleryViews=['browse','trending','new','uploads'];
  const stg=document.getElementById('sizeToggleGroup');
  if(stg) stg.style.display=galleryViews.includes(view)?'flex':'none';
  // Clear-all button for uploads view injected after size toggle
  const existingClr=document.getElementById('clrAllBtn');
  if(existingClr) existingClr.remove();
  if(view==='uploads'){
    const clr=document.createElement('button');
    clr.id='clrAllBtn';
    clr.className='btn btn-ghost';
    clr.style.color='var(--red)';
    clr.innerHTML='<i class="ti ti-trash"></i> Clear All';
    clr.onclick=clearAllUploads;
    document.getElementById('topbarRight').appendChild(clr);
  }
}
// ── Gallery Size ──────────────────────────────────────────────────────────────
let gallerySize='medium';
function setGallerySize(size,btn){
  gallerySize=size;
  document.querySelectorAll('.size-btn').forEach(b=>b.classList.remove('active'));
  if(btn) btn.classList.add('active');
  // Apply to all gallery elements
  ['browseGallery','uploadsGallery'].forEach(id=>{
    const g=document.getElementById(id);
    if(g){g.className='gallery sz-'+size;}
  });
}
function rerenderActive(){ const bv=['browse','trending','new']; if(bv.includes(currentView)) renderBrowse(); else if(currentView==='uploads') renderUploads(); else if(currentView==='videos') renderScannedVideos(); }
function setTab(el,cat){ document.querySelectorAll('.tab').forEach(t=>t.classList.remove('active')); el.classList.add('active'); activeTabCat=cat; renderBrowse(); }
function onSearch(q){ searchQuery=q.toLowerCase().trim(); rerenderActive(); }

// ── Music Player ──────────────────────────────────────────────────────────────
let playlist=[],trackIdx=0,isPlaying=false,isShuffle=false,isRepeat=false,isMuted=false,progTimer=null;
const audioEl=document.getElementById('audioEl');
function pickMusic(){ if(window.webkit?.messageHandlers?.pickMusic) window.webkit.messageHandlers.pickMusic.postMessage({}); }
function onMusicPicked(tracks){ if(!tracks?.length) return; playlist=playlist.concat(tracks); if(playlist.length===tracks.length){trackIdx=0;loadTrack(0);playAudio();} document.getElementById('musicBar').classList.remove('hidden'); showToast('\u{266B} Added '+tracks.length+' track'+(tracks.length!==1?'s':'')); }
function loadTrack(i){ const t=playlist[i]; audioEl.src=t.path; document.getElementById('musicTitle').textContent=t.name.replace(/\\.[^.]+$/,''); document.getElementById('musicArtist').textContent='Local File'; document.getElementById('progFill').style.width='0%'; document.getElementById('timeEl').textContent='0:00'; drawArt(t.name); }
function drawArt(name){ const art=document.getElementById('musicArt'); art.innerHTML='<canvas width="38" height="38" id="artCv"></canvas>'; const cv=document.getElementById('artCv'),ctx=cv.getContext('2d'); let h=0; for(let i=0;i<name.length;i++) h=(h*31+name.charCodeAt(i))>>>0; const h1=h%360,h2=(h1+120)%360; const g=ctx.createLinearGradient(0,0,38,38); g.addColorStop(0,`hsl(${h1},70%,22%)`); g.addColorStop(1,`hsl(${h2},80%,32%)`); ctx.fillStyle=g; ctx.fillRect(0,0,38,38); ctx.fillStyle=`hsla(${h1},100%,65%,0.55)`; ctx.beginPath(); ctx.arc(19,19,9,0,Math.PI*2); ctx.fill(); }
function playAudio(){ audioEl.play().catch(()=>{}); isPlaying=true; updatePlayBtn(); startProg(); }
function pauseAudio(){ audioEl.pause(); isPlaying=false; updatePlayBtn(); }
function togglePlay(){
  if (playlist.length === 0) {
    pickMusic();
    return;
  }
  isPlaying?pauseAudio():playAudio();
}
function updatePlayBtn(){ document.getElementById('playIcon').className=isPlaying?'ti ti-player-pause':'ti ti-player-play'; }
function prevTrack(){ trackIdx=(trackIdx-1+playlist.length)%playlist.length; loadTrack(trackIdx); if(isPlaying) playAudio(); }
function nextTrack(){ if(isShuffle) trackIdx=Math.floor(Math.random()*playlist.length); else trackIdx=(trackIdx+1)%playlist.length; loadTrack(trackIdx); if(isPlaying) playAudio(); }
function toggleShuffle(){ isShuffle=!isShuffle; document.getElementById('btnShuffle').classList.toggle('on',isShuffle); }
function toggleRepeat(){ isRepeat=!isRepeat; document.getElementById('btnRepeat').classList.toggle('on',isRepeat); }
function toggleMute(){ isMuted=!isMuted; audioEl.muted=isMuted; document.getElementById('volIcon').className=isMuted?'ti ti-volume-off':'ti ti-volume'; }
function setVol(v){ audioEl.volume=v/100; }
function startProg(){ clearInterval(progTimer); progTimer=setInterval(()=>{ if(!audioEl.duration) return; document.getElementById('progFill').style.width=(audioEl.currentTime/audioEl.duration*100)+'%'; document.getElementById('timeEl').textContent=fmt(audioEl.currentTime); document.getElementById('timeDur').textContent=fmt(audioEl.duration); },500); }
function seekTo(e){ const pct=(e.clientX-e.currentTarget.getBoundingClientRect().left)/e.currentTarget.offsetWidth; if(audioEl.duration) audioEl.currentTime=pct*audioEl.duration; }
function fmt(s){ return Math.floor(s/60)+':'+(('0'+Math.floor(s%60)).slice(-2)); }
audioEl.addEventListener('ended',()=>{ if(isRepeat){audioEl.currentTime=0;playAudio();}else nextTrack(); });
audioEl.addEventListener('loadedmetadata',()=>{ document.getElementById('timeDur').textContent=fmt(audioEl.duration); });
audioEl.volume=0.8;

document.getElementById('uploadModal').addEventListener('click',function(e){if(e.target===this)closeUploadModal();});
document.getElementById('paywallModal').addEventListener('click',function(e){if(e.target===this)closePaywall();});
document.getElementById('settingsModal').addEventListener('click',function(e){if(e.target===this)closeSettings();});

// ── Settings ─────────────────────────────────────────────────────────────────
function openSettings(){ document.getElementById('settingsModal').classList.add('open'); }
function closeSettings(){ document.getElementById('settingsModal').classList.remove('open'); }
function settingsClearCache(){
  if (confirm("Are you sure you want to clear the App Cache?")) {
    if (confirm("This will clear all WebView cache and temporary files. Are you absolutely sure you want to proceed?")) {
      closeSettings();
      if(window.webkit?.messageHandlers?.clearCache) window.webkit.messageHandlers.clearCache.postMessage({});
    }
  }
}
function settingsClearUploads(){
  if (confirm("Are you sure you want to clear your Video Collection Library?")) {
    if (confirm("This will remove all items from your collection. Original files on disk will NOT be deleted. Are you absolutely sure?")) {
      closeSettings();
      if(window.webkit?.messageHandlers?.clearUploads) window.webkit.messageHandlers.clearUploads.postMessage({});
    }
  }
}
function settingsClearLocalVideos(){
  if (confirm("Are you sure you want to clear all Local Videos?")) {
    if (confirm("This will remove all scanned local video entries from the list (files are kept on disk). Are you absolutely sure?")) {
      closeSettings();
      if(window.webkit?.messageHandlers?.clearScannedVideos) window.webkit.messageHandlers.clearScannedVideos.postMessage({});
    }
  }
}
const dz=document.getElementById('dropZone');
dz.addEventListener('dragover',e=>{e.preventDefault();dz.classList.add('drag')});
dz.addEventListener('dragleave',()=>dz.classList.remove('drag'));
dz.addEventListener('drop',e=>{e.preventDefault();dz.classList.remove('drag');triggerUpload();});

let toastTimer;
function showToast(msg){ const t=document.getElementById('toast'); t.textContent=msg; t.classList.add('show'); clearTimeout(toastTimer); toastTimer=setTimeout(()=>t.classList.remove('show'),2400); }

renderBrowse();

// ── Browse Online (wallsflow.com) ──────────────────────────────────────────────────
const WALLSFLOW = [
  { title:'Beautiful Sky Drive',          cat:'Cars',    page:'https://wallsflow.com/live-wallpapers/cars/1020-beautiful-sky-drive-live-wallpaper.html',            thumb:'https://cloud.wallsflow.com/posts/2026-05/c3d9bb37fd_beautiful-sky-drive-live-wallpaper-wallsflow-com.webp',            video:'https://cloud.wallsflow.com/files/2026-05/234918297f_beautiful-sky-drive-live-wallpaper-wallsflow-com.mp4' },
  { title:'Shirou and Saber Together',    cat:'Anime',   page:'https://wallsflow.com/live-wallpapers/anime/1019-shirou-and-saber-together-live-wallpaper.html',          thumb:'https://cloud.wallsflow.com/posts/2026-05/a78cacd072_shirou-and-saber-together-live-wallpaper-wallsflow-com.webp',          video:'https://cloud.wallsflow.com/files/2026-05/326f2bbf90_shirou-and-saber-together-live-wallpaper-wallsflow-com.mp4' },
  { title:'Red Warrior',                  cat:'Anime',   page:'https://wallsflow.com/live-wallpapers/anime/1018-red-warrior-live-wallpaper.html',                        thumb:'https://cloud.wallsflow.com/posts/2026-05/665045f1bf_red-warrior-live-wallpaper-wallsflow-com.webp',                        video:'https://cloud.wallsflow.com/files/2026-05/7d65c9fe11_red-warrior-live-wallpaper-wallsflow-com.mp4' },
  { title:'Celestial Dreams',             cat:'Other',   page:'https://wallsflow.com/live-wallpapers/other/1017-celestial-dreams-live-wallpaper.html',                   thumb:'https://cloud.wallsflow.com/posts/2026-05/efdf2b5186_celestial-dreams-live-wallpaper-wallsflow-com.webp',                   video:'https://cloud.wallsflow.com/files/2026-05/3ec0fc9b75_celestial-dreams-live-wallpaper-wallsflow-com.mp4' },
  { title:'Silent Rain City',             cat:'Other',   page:'https://wallsflow.com/live-wallpapers/other/1016-silent-rain-city-live-wallpaper.html',                   thumb:'https://cloud.wallsflow.com/posts/2026-05/dd8b9a7bc9_silent-rain-city-live-wallpaper-wallsflow-com.webp',                   video:'https://cloud.wallsflow.com/files/2026-05/23ece56017_silent-rain-city-live-wallpaper-wallsflow-com.mp4' },
  { title:'Silent Garden Night',          cat:'Other',   page:'https://wallsflow.com/live-wallpapers/other/1015-silent-garden-night-live-wallpaper.html',               thumb:'https://cloud.wallsflow.com/posts/2026-05/98937bc0d1_silent-garden-night-live-wallpaper-wallsflow-com.webp',               video:'https://cloud.wallsflow.com/files/2026-05/689ee268a0_silent-garden-night-live-wallpaper-wallsflow-com.mp4' },
  { title:'Minecraft Peaceful Sunrise',   cat:'Games',   page:'https://wallsflow.com/live-wallpapers/games/506-minecraft-tranquil-morning-pond-live-wallpaper.html',     thumb:'https://cloud.wallsflow.com/posts/2025-06/03adc58bba_minecraft-peaceful-sunrise-by-the-pond-live-wallpaper.webp',             video:'https://cloud.wallsflow.com/files/2025-06/c8f816f17c_minecraft-tranquil-morning-pond.mp4' },
  { title:'BMW M4 Liberty Walk',          cat:'Cars',    page:'https://wallsflow.com/live-wallpapers/cars/41-bmw-m4-liberty-walk-tuning-aesthetic-live-wallpaper.html', thumb:'https://cloud.wallsflow.com/posts/2025-04/901c8942d2_bmw_m4_liberty_walk_4k.webp',                                          video:'https://cloud.wallsflow.com/files/2025-08/4393fa7f47_bmw_m4_liberty_walk.mp4' },
  { title:'Aurora Forest Night',          cat:'Winter',  page:'https://wallsflow.com/live-wallpapers/winter/648-aurora-forest-night-live-wallpaper.html',               thumb:'https://cloud.wallsflow.com/posts/2025-12/9c4832d925_aurora-forest-night-live-wallpaper-wallsflow-com.webp',               video:'https://cloud.wallsflow.com/files/2025-12/ff43a2b538_aurora-forest-night-live-wallpaper-wallsflow-com.mp4' },
  { title:'Gojo Satoru Train',            cat:'Anime',   page:'https://wallsflow.com/live-wallpapers/anime/878-gojo-satoru-neon-rain-train-live-wallpaper-4k.html',      thumb:'https://cloud.wallsflow.com/posts/2026-03/7da065be63_gojo-satoru-neon-rain-train-live-wallpaper-4k-wallsflow-com.webp',      video:'https://cloud.wallsflow.com/files/2026-03/ce7711c1e0_gojo-satoru-neon-rain-train-live-wallpaper-4k-wallsflow-com.mp4' },
  { title:'Nier Automata 2B Forest Ruins', cat:'Games', page:'https://wallsflow.com/live-wallpapers/games/950-nier-automata-2b-forest-ruins-live-wallpaper.html', thumb:'https://cloud.wallsflow.com/posts/2026-04/4583309040_nier-automata-2b-forest-ruins-live-wallpaper_preview.webp', video:'https://cloud.wallsflow.com/files/2026-04/5abfd0d698_nier-automata-2b-forest-ruins-live-wallpaper-wallsflow-com.mp4' },
  { title:'Metro 2039 Between Fire and Ash', cat:'Games', page:'https://wallsflow.com/live-wallpapers/games/948-metro-2039-between-fire-and-ash-animated-wallpaper.html', thumb:'https://cloud.wallsflow.com/posts/2026-04/999410bc23_metro-2039-between-fire-and-ash-animated-wallpaper.webp', video:'https://cloud.wallsflow.com/files/2026-04/0d7b6a1091_metro-2039-between-fire-and-ash-animated-wallpaper-wallsflow-com.mp4' },
  { title:'Charmander Pokemon', cat:'Games', page:'https://wallsflow.com/live-wallpapers/games/937-charmander-pokemon-fire-glow-forest-live-wallpaper.html', thumb:'https://cloud.wallsflow.com/posts/2026-04/a88f3cffc3_charmander-pokemon-fire-glow-forest-live-wallpaper-wallsflow-com.webp', video:'https://cloud.wallsflow.com/files/2026-04/0a198f9e4e_charmander-pokemon-fire-glow-forest-live-wallpaper-wallsflow-com.mp4' },
  { title:'Pixel Pokémon Mini World', cat:'Games', page:'https://wallsflow.com/live-wallpapers/games/913-pixel-pokemon-mini-world-live-wallpaper.html', thumb:'https://cloud.wallsflow.com/posts/2026-04/9e2db2965f_pixel-pokemon-mini-world-live-wallpaper-wallsflow-com.webp', video:'https://cloud.wallsflow.com/files/2026-04/05f5d7bfdf_pixel-pokemon-mini-world-live-wallpaper-wallsflow-com.mp4' },
  { title:'Minecraft Cherry Blossom Sunrise Valley', cat:'Games', page:'https://wallsflow.com/live-wallpapers/games/885-minecraft-cherry-blossom-sunrise-valley-live-wallpaper-4k.html', thumb:'https://cloud.wallsflow.com/posts/2026-03/aa2c466617_minecraft-cherry-blossom-sunrise-valley-wallsflow-com.webp', video:'https://cloud.wallsflow.com/files/2026-03/861f5857fd_minecraft-cherry-blossom-sunrise-valley-wallsflow-com.mp4' },
  { title:'Minecraft Dog in a Boat', cat:'Games', page:'https://wallsflow.com/live-wallpapers/games/260-minecraft-dog-in-a-boat-live-wallpaper.html', thumb:'https://cloud.wallsflow.com/posts/2025-08/02d0e43af3_minecraft-dog-in-a-boat-relaxing-4k-live-wallpaper-for-gamers.webp', video:'https://cloud.wallsflow.com/files/2025-08/0564dd33e2_minecraft-dog-in-a-boat.mp4' },
  { title:'Halo Master Chief Zen Meditation', cat:'Games', page:'https://wallsflow.com/live-wallpapers/games/882-halo-master-chief-zen-meditation-live-wallpaper-4k.html', thumb:'https://cloud.wallsflow.com/posts/2026-03/183f608593_halo-master-chief-zen-meditation-wallsflow-com.webp', video:'https://cloud.wallsflow.com/files/2026-03/4f99924630_halo-master-chief-zen-meditation-wallsflow-com.mp4' },
  { title:'Minecraft Enchanted Forest Sun Rays', cat:'Games', page:'https://wallsflow.com/live-wallpapers/games/875-minecraft-enchanted-forest-sun-rays-live-wallpaper.html', thumb:'https://cloud.wallsflow.com/posts/2026-03/8ec5ad3a66_minecraft-enchanted-forest-sun-rays-wallsflow-com.webp', video:'https://cloud.wallsflow.com/files/2026-03/93b6e09717_minecraft-enchanted-forest-sun-rays-wallsflow-com.mp4' },
  { title:'Ghost of Tsushima Style', cat:'Games', page:'https://wallsflow.com/live-wallpapers/games/869-ghost-of-tsushima-style-crimson-samurai-autumn-live-wallpaper-4k.html', thumb:'https://cloud.wallsflow.com/posts/2026-03/c95a50166b_ghost-of-tsushima-style-crimson-samurai-wallsflow-com.webp', video:'https://cloud.wallsflow.com/files/2026-03/b74084dd51_ghost-of-tsushima-style-crimson-samurai-wallsflow-com.mp4' },
  { title:'Minecraft Snowy Village', cat:'Games', page:'https://wallsflow.com/live-wallpapers/games/864-minecraft-snowy-village-night-live-wallpaper.html', thumb:'https://cloud.wallsflow.com/posts/2026-03/179e4f6b4c_minecraft-falling-snow_wallsflow-com.webp', video:'https://cloud.wallsflow.com/files/2026-03/345a9660ef_minecraft-falling-snow-wallsflow-com.mp4' },
  { title:'Arknights Endfield Sakura Sanctuary', cat:'Games', page:'https://wallsflow.com/live-wallpapers/games/777-arknights-endfield-sakura-sanctuary-live-wallpaper.html', thumb:'https://cloud.wallsflow.com/posts/2026-02/8d8eb8f6eb_arknights-endfield-sakura-sanctuary-live-wallpaper-wallsflow-com.webp', video:'https://cloud.wallsflow.com/files/2026-02/86d39f417b_arknights-endfield-sakura-sanctuary-live-wallpaper-wallsflow-com.mp4' },
  { title:'Cherry Blossom Grove', cat:'Games', page:'https://wallsflow.com/live-wallpapers/games/820-cherry-blossom-grove-minecraft-spring-live-wallpaper.html', thumb:'https://cloud.wallsflow.com/posts/2026-03/ddfc7498d3_cherry-blossom-grove-minecraft-spring-live-wallpaper-wallsflow-com.webp', video:'https://cloud.wallsflow.com/files/2026-03/361b6cd906_cherry-blossom-grove-minecraft-spring-live-wallpaper-wallsflow-com.mp4' },
  { title:'Samurai Sunset Meditation', cat:'Games', page:'https://wallsflow.com/live-wallpapers/games/854-samurai-sunset-meditation-ghost-of-tsushima-style-live-wallpaper.html', thumb:'https://cloud.wallsflow.com/posts/2026-03/93d5e7d06d_samurai-sunset-meditation-ghost-of-tsushima-style-live-wallpaper-wallsflow-com.webp', video:'https://cloud.wallsflow.com/files/2026-03/53d59fe238_samurai-sunset-meditation-ghost-of-tsushima-style-live-wallpaper-wallsflow-com.mp4' },
  { title:'Galbrena Dual Energy Eyes', cat:'Games', page:'https://wallsflow.com/live-wallpapers/games/847-galbrena-dual-energy-eyes-live-wallpaper.html', thumb:'https://cloud.wallsflow.com/posts/2026-03/03a8a74ebf_galbrena-dual-energy-eyes-live-wallpaper-wallsflow-com.webp', video:'https://cloud.wallsflow.com/files/2026-03/cc35d9b64c_galbrena-dual-energy-eyes-live-wallpaper-wallsflow-com.mp4' },
  { title:'Key Art Ghost of Yōtei', cat:'Games', page:'https://wallsflow.com/live-wallpapers/games/842-key-art-ghost-of-yotei-live-wallpaper.html', thumb:'https://cloud.wallsflow.com/posts/2026-03/db6a1bc88b_key-art-ghost-of-yotei-live-wallpaper-wallsflow-com.webp', video:'https://cloud.wallsflow.com/files/2026-03/90bf8a12ac_key-art-ghost-of-yotei-live-wallpaper-wallsflow-com.mp4' },
  { title:'Ghost of Yōtei', cat:'Games', page:'https://wallsflow.com/live-wallpapers/games/836-ghost-of-yotei-atsu-samurai-live-wallpaper.html', thumb:'https://cloud.wallsflow.com/posts/2026-03/6ef5ac6154_ghost-of-yotei-atsu-samurai-live-wallpaper-wllsflow-com.webp', video:'https://cloud.wallsflow.com/files/2026-03/81a9cb1e2f_ghost-of-yotei-atsu-samurai-live-wallpaper-wllsflow-com.mp4' },
  { title:'PlayStation Pixel Art Controller', cat:'Games', page:'https://wallsflow.com/live-wallpapers/games/833-playstation-pixel-art-controller-retro-gaming-live-wallpaper.html', thumb:'https://cloud.wallsflow.com/posts/2026-03/b66d53f494_playstation-pixel-art-controller-retro-gaming-live-wallpaper-wallsflow-com.webp', video:'https://cloud.wallsflow.com/files/2026-03/108e160494_playstation-pixel-art-controller-retro-gaming-live-wallpaper-wallsflow-com.mp4' },
  { title:'Fog Encounter', cat:'Games', page:'https://wallsflow.com/live-wallpapers/other/822-fog-encounter-dark-forest-live-wallpaper.html', thumb:'https://cloud.wallsflow.com/posts/2026-03/7e0cb35433_fog-encounter-dark-forest-live-wallpaper-wallsflow-com.webp', video:'https://cloud.wallsflow.com/files/2026-03/ffb02e685b_fog-encounter-dark-forest-live-wallpaper-wallsflow-com.mp4' },
  { title:'Genshin Impact', cat:'Games', page:'https://wallsflow.com/live-wallpapers/games/821-genshin-impact-paimon-night-camp-live-wallpaper.html', thumb:'https://cloud.wallsflow.com/posts/2026-03/eb0409f8c1_genshin-impact-paimon-night-camp-live-wallpaper-wallsflow-com.webp', video:'https://cloud.wallsflow.com/files/2026-03/c35705b19c_genshin-impact-paimon-night-camp-live-wallpaper-wallsflow-com.mp4' },
  { title:'Cyberpunk City Style', cat:'Games', page:'https://wallsflow.com/live-wallpapers/games/819-cyberpunk-city-style-night-patrol-live-wallpaper.html', thumb:'https://cloud.wallsflow.com/posts/2026-02/7dc34704bb_cyberpunk-city-style-night-patrol-live-wallpaper-wallsflow-com.webp', video:'https://cloud.wallsflow.com/files/2026-02/18db78c686_cyberpunk-city-style-night-patrol-live-wallpaper-wallsflow-com.mp4' },
  { title:'Retro Donkey Kong Gaming Room', cat:'Games', page:'https://wallsflow.com/live-wallpapers/games/818-retro-donkey-kong-gaming-room-live-wallpaper.html', thumb:'https://cloud.wallsflow.com/posts/2026-02/3b6f931a9e_retro-donkey-kong-gaming-room-live-wallpaper-wallsflow-com.webp', video:'https://cloud.wallsflow.com/files/2026-02/9d570b13b5_retro-donkey-kong-gaming-room-live-wallpaper-wallsflow-com.mp4' },
  { title:'The Unreliable', cat:'Games', page:'https://wallsflow.com/live-wallpapers/games/810-the-unreliable-outer-worlds-live-wallpaper.html', thumb:'https://cloud.wallsflow.com/posts/2026-02/027a1a7158_the-unreliable-outer-worlds-live-wallpaper-wallsflow-com.webp', video:'https://cloud.wallsflow.com/files/2026-02/61a84ab0f4_the-unreliable-outer-worlds-live-wallpaper-wallsflow-com.mp4' },
  { title:'The Witcher 3 Pixel Sunset', cat:'Games', page:'https://wallsflow.com/live-wallpapers/games/808-witcher-3-pixel-sunset-geralt-live-wallpaper.html', thumb:'https://cloud.wallsflow.com/posts/2026-02/1f6462eb8b_witcher-3-pixel-sunset-geralt-live-wallpaper-wallsflow-com.webp', video:'https://cloud.wallsflow.com/files/2026-02/96d33bef74_witcher-3-pixel-sunset-geralt-live-wallpaper-wallsflow-com.mp4' },
  { title:'Momodora Mystic Forest', cat:'Games', page:'https://wallsflow.com/live-wallpapers/games/803-momodora-mystic-forest-pixel-live-wallpaper.html', thumb:'https://cloud.wallsflow.com/posts/2026-02/04f0d49bf0_momodora-mystic-forest-pixel-live-wallpaper-wallsflow-com.webp', video:'https://cloud.wallsflow.com/files/2026-02/2d3346279d_momodora-mystic-forest-pixel-live-wallpaper-wallsflow-com.mp4' },
  { title:'Old Mountain Church', cat:'Games', page:'https://wallsflow.com/live-wallpapers/games/797-old-mountain-church-game-landscape-live-wallpaper.html', thumb:'https://cloud.wallsflow.com/posts/2026-02/67d5812969_old-mountain-church-game-landscape-live-wallpaper-wallsflow-com.webp', video:'https://cloud.wallsflow.com/files/2026-02/47700b665b_old-mountain-church-game-landscape-live-wallpaper-wallsflow-com.mp4' },
  { title:'Minecraft Golden Sunset', cat:'Games', page:'https://wallsflow.com/live-wallpapers/games/789-minecraft-golden-sunset-cherry-blossom-live-wallpaper.html', thumb:'https://cloud.wallsflow.com/posts/2026-02/f9ac5b4109_minecraft-golden-sunset-cherry-blossom-live-wallpaper-wallsflow-com.webp', video:'https://cloud.wallsflow.com/files/2026-02/981acc1674_minecraft-golden-sunset-cherry-blossom-live-wallpaper-wallsflow-com.mp4' },
  { title:'Super Mario Retro Gamer Room', cat:'Games', page:'https://wallsflow.com/live-wallpapers/games/788-super-mario-retro-gamer-room-pixel-night-live-wallpaper.html', thumb:'https://cloud.wallsflow.com/posts/2026-02/ce118bb44b_super-mario-retro-gamer-room-pixel-night-live-wallpaper-wallsflow-com.webp', video:'https://cloud.wallsflow.com/files/2026-02/847c6ebc6b_super-mario-retro-gamer-room-pixel-night-live-wallpaper-wallsflow-com.mp4' },
  { title:'Minecraft Winter', cat:'Games', page:'https://wallsflow.com/live-wallpapers/games/775-minecraft-winter-lantern-night-live-wallpaper.html', thumb:'https://cloud.wallsflow.com/posts/2026-02/887db0ccdb_minecraft-winter-lantern-night-live-wallpaper-wallsflow-com.webp', video:'https://cloud.wallsflow.com/files/2026-02/e7af7ef8a9_minecraft-winter-lantern-night-live-wallpaper-wallsflow-com.mp4' },
  { title:'Fortnite Storm Lake', cat:'Games', page:'https://wallsflow.com/live-wallpapers/games/774-fortnite-storm-lake-night-scene-live-wallpaper.html', thumb:'https://cloud.wallsflow.com/posts/2026-02/a51788988c_fortnite-storm-lake-night-scene-live-wallpaper-wallsflow-com.webp', video:'https://cloud.wallsflow.com/files/2026-02/5ee02eb721_fortnite-storm-lake-night-scene-live-wallpaper-wallsflow-com.mp4' },
  { title:'Neon Cyber City', cat:'Games', page:'https://wallsflow.com/live-wallpapers/games/773-neon-cyber-city-fortnite-style-live-wallpaper.html', thumb:'https://cloud.wallsflow.com/posts/2026-02/ec67bd2860_neon-cyber-city-fortnite-style-live-wallpaper-wallsflow-com.webp', video:'https://cloud.wallsflow.com/files/2026-02/1b37111002_neon-cyber-city-fortnite-style-live-wallpaper-wallsflow-com.mp4' },
  { title:'Neon Apocalypse', cat:'Games', page:'https://wallsflow.com/live-wallpapers/games/772-neon-apocalypse-zombie-survival-live-wallpaper.html', thumb:'https://cloud.wallsflow.com/posts/2026-02/2cf4162cc8_neon-apocalypse-zombie-survival-live-wallpaper-wallsflow-com.webp', video:'https://cloud.wallsflow.com/files/2026-02/387589a6a8_neon-apocalypse-zombie-survival-live-wallpaper-wallsflow-com.mp4' },
  { title:'Elden Ring Burning Sigil', cat:'Games', page:'https://wallsflow.com/live-wallpapers/games/754-elden-ring-burning-sigil-live-wallpaper.html', thumb:'https://cloud.wallsflow.com/posts/2026-02/841964419e_elden-ring-burning-sigil-live-wallpaper-wallsflow-com.webp', video:'https://cloud.wallsflow.com/files/2026-02/b9200a3bef_elden-ring-burning-sigil-live-wallpaper-wallsflow-com.mp4' },
  { title:'Elden Ring Throne of Ashes', cat:'Games', page:'https://wallsflow.com/live-wallpapers/games/753-elden-ring-throne-of-ashes-live-wallpaper.html', thumb:'https://cloud.wallsflow.com/posts/2026-02/a8f0a65959_elden-ring-throne-of-ashes-live-wallpaper-wallsflow-com.webp', video:'https://cloud.wallsflow.com/files/2026-02/e90fccc9de_elden-ring-throne-of-ashes-live-wallpaper-wallsflow-com.mp4' },
  { title:'Minecraft Murky Waters', cat:'Games', page:'https://wallsflow.com/live-wallpapers/games/751-minecraft-murky-waters-ambient-live-wallpaper.html', thumb:'https://cloud.wallsflow.com/posts/2026-02/f453a58e7e_minecraft-murky-waters-ambient-live-wallpaper-wallsflow-com.webp', video:'https://cloud.wallsflow.com/files/2026-02/06dbee472e_minecraft-murky-waters-ambient-live-wallpaper-wallsflow-com.mp4' },
  { title:'Minecraft Blade of Enchantment', cat:'Games', page:'https://wallsflow.com/live-wallpapers/games/750-minecraft-blade-of-enchantment-live-wallpaper.html', thumb:'https://cloud.wallsflow.com/posts/2026-02/63281ffa85_minecraft-blade-of-enchantment-live-wallpaper-wallsflow-com.webp', video:'https://cloud.wallsflow.com/files/2026-02/f3fca9fe06_minecraft-blade-of-enchantment-live-wallpaper-wallsflow-com.mp4' },
  { title:'Pokémon Emerald Ride', cat:'Games', page:'https://wallsflow.com/live-wallpapers/pixel-art/727-pokemon-emerald-pixel-coast-journey-live-wallpaper.html', thumb:'https://cloud.wallsflow.com/posts/2026-01/a2f9b26c1e_pokemon-emerald-pixel-coast-journey-live-wallpaper-wallsflow-com.webp', video:'https://cloud.wallsflow.com/files/2026-01/26aa09b249_pokemon-emerald-pixel-coast-journey-live-wallpaper-wallsflow-com.mp4' },
  { title:'Portal of Adventure', cat:'Games', page:'https://wallsflow.com/live-wallpapers/games/705-portal-of-adventure-fantasy-quest-live-wallpaper.html', thumb:'https://cloud.wallsflow.com/posts/2026-01/e7e8810e80_portal-of-adventure-fantasy-quest-live-wallpaper-wallsflow-com.webp', video:'https://cloud.wallsflow.com/files/2026-01/da91480383_portal-of-adventure-fantasy-quest-live-wallpaper-wallsflow-com.mp4' },
  { title:'Minecraft Night Farm', cat:'Games', page:'https://wallsflow.com/live-wallpapers/games/704-minecraft-night-farm-cozy-village-live-wallpaper.html', thumb:'https://cloud.wallsflow.com/posts/2026-01/086626f42b_minecraft-night-farm-cozy-village-live-wallpaper-wallsflow-com.webp', video:'https://cloud.wallsflow.com/files/2026-01/4794f7bbdc_minecraft-night-farm-cozy-village-live-wallpaper-wallsflow-com.mp4' },
  { title:'Spider-Man: Night City Watcher', cat:'Games', page:'https://wallsflow.com/live-wallpapers/games/702-spider-man-night-city-watcher-live-wallpaper.html', thumb:'https://cloud.wallsflow.com/posts/2026-01/5b1ce859dd_spider-man-night-city-watcher-live-wallpaper-wallsflow-com.webp', video:'https://cloud.wallsflow.com/files/2026-01/6cf44bf7f3_spider-man-night-city-watcher-live-wallpaper-wallsflow-com.mp4' },
  { title:'Wisteria Reflections', cat:'Games', page:'https://wallsflow.com/live-wallpapers/games/696-wisteria-reflections-night-lake-live-wallpaper.html', thumb:'https://cloud.wallsflow.com/posts/2026-01/e8916a1766_wisteria-reflections-night-lake-live-wallpaper-wallsflow-com.webp', video:'https://cloud.wallsflow.com/files/2026-01/652baf4741_wisteria-reflections-night-lake-live-wallpaper-wallsflow-com.mp4' },
];

const CAT_COLORS = { Anime:'var(--accent)', Cars:'var(--amber)', Games:'var(--green)', Winter:'#60a5fa', Other:'var(--muted)', Nature:'var(--green)', Space:'#818cf8', Movies:'var(--red)', People:'#f472b6', Minimalist:'var(--muted)', Graphics:'var(--accent2)' };

// Download dir — updated by Swift callback
let downloadDir = '~/Downloads';
function onDownloadDirChanged(path){
  downloadDir = path;
  const el = document.getElementById('dlDirLabel');
  if(el) el.textContent = path;
}

function openDownloadDirPicker(){
  if(window.webkit?.messageHandlers?.setDownloadDir) window.webkit.messageHandlers.setDownloadDir.postMessage({});
}

function downloadWallpaper(videoUrl, title, btnEl){
  if(!window.webkit?.messageHandlers?.downloadVideo){ showToast('Download not available'); return; }
  btnEl.innerHTML = '<i class="ti ti-loader-2" style="animation:spin .8s linear infinite"></i>';
  btnEl.style.pointerEvents='none';
  window.webkit.messageHandlers.downloadVideo.postMessage({url: videoUrl, title});
}

function onDownloadComplete(title){
  showToast('✓ Saved: ' + title);
  // Re-enable any still-spinning buttons (safety)
  document.querySelectorAll('.bo-dl-btn').forEach(b => {
    if(b.dataset.title === title){
      b.innerHTML = '<i class="ti ti-check"></i>';
      b.style.background = 'var(--green)';
    }
  });
}

function onDownloadFailed(title, err){
  showToast('✗ Failed: ' + title);
  document.querySelectorAll('.bo-dl-btn[data-title="' + title + '"]').forEach(b => {
    b.innerHTML = '<i class="ti ti-download"></i> Save';
    b.style.pointerEvents='';
    b.style.background='';
  });
}

function renderOnlineGrid(list) {
  const grid = document.getElementById('boGrid'); if(!grid) return;
  grid.innerHTML = '';
  if (!list || list.length === 0) {
    grid.innerHTML = `
      <div style="grid-column:1/-1;text-align:center;padding:40px;color:var(--muted);font-size:12px">
        No wallpapers found
      </div>
    `;
    return;
  }
  list.forEach(w => {
    const safeTitle = w.title.replace(/"/g,'&quot;');
    const card = document.createElement('div');
    card.className = 'bo-card';
    const catColor = CAT_COLORS[w.cat] || 'var(--muted)';
    card.innerHTML = `
      <div class="bo-thumb">
        <img src="${w.thumb}" loading="lazy" alt="${w.title}">
        <video src="${w.video}" muted loop playsinline preload="none"></video>
        <div class="bo-cat-badge" style="background:${catColor};color:${w.cat==='Cars'||w.cat==='Winter'?'#0a0a0f':'#fff'}">${w.cat}</div>
        <button class="bo-dl-btn" data-title="${safeTitle}" onclick="event.stopPropagation();downloadWallpaper('${w.video}','${safeTitle}',this)">
          <i class="ti ti-download"></i> Save
        </button>
      </div>
      <div class="bo-info">
        <div class="bo-title">${w.title}</div>
      </div>`;
    const vid = card.querySelector('video');
    card.addEventListener('mouseenter', () => { vid.load(); vid.play().catch(()=>{}); });
    card.addEventListener('mouseleave', () => { vid.pause(); vid.currentTime=0; });
    grid.appendChild(card);
  });
}

let searchDebounceTimer;
function onOnlineSearchInputChanged() {
  const searchInput = document.getElementById('boSearchInput');
  const query = searchInput ? searchInput.value.trim() : '';

  clearTimeout(searchDebounceTimer);

  if (!query) {
    renderOnlineGrid(WALLSFLOW);
    return;
  }

  // Show loading spinner
  const grid = document.getElementById('boGrid');
  if (grid) {
    grid.innerHTML = `
      <div style="grid-column:1/-1;display:flex;flex-direction:column;align-items:center;justify-content:center;padding:60px 0;color:var(--muted)">
        <i class="ti ti-loader-2" style="font-size:28px;animation:spin .8s linear infinite;margin-bottom:10px"></i>
        <div style="font-size:12px">Searching wallpapers...</div>
      </div>
    `;
  }

  searchDebounceTimer = setTimeout(() => {
    if (window.webkit?.messageHandlers?.searchOnline) {
      window.webkit.messageHandlers.searchOnline.postMessage({ query });
    } else {
      // Fallback
      const filtered = WALLSFLOW.filter(w =>
        w.title.toLowerCase().includes(query.toLowerCase()) ||
        w.cat.toLowerCase().includes(query.toLowerCase())
      );
      renderOnlineGrid(filtered);
    }
  }, 400);
}

function renderBrowseOnline(){
  const searchInput = document.getElementById('boSearchInput');
  if (searchInput && searchInput.value.trim()) {
    onOnlineSearchInputChanged();
  } else {
    renderOnlineGrid(WALLSFLOW);
  }
}

function onOnlineSearchResults(results) {
  renderOnlineGrid(results);
}

function onOnlineSearchFailed(err) {
  const grid = document.getElementById('boGrid');
  if (grid) {
    grid.innerHTML = `
      <div style="grid-column:1/-1;text-align:center;padding:40px;color:var(--red);font-size:12px">
        Search failed: ${err}
      </div>
    `;
  }
}

function openExternalURL(url){
  if(window.webkit?.messageHandlers?.openURL) window.webkit.messageHandlers.openURL.postMessage({url});
}

renderBrowseOnline();
// Load saved UI Theme, Background, Transparency, and Custom BG Image on startup
loadSavedTheme();
loadSavedBg();
loadSavedTransparency();
loadSavedBgImage();
// Initialize stats and open Home view as default
updateDashboardStats();
switchView('home', document.getElementById('nav-home'));
// Note: userUploads and scannedVideos are populated by Swift callbacks after page load

</script>
</body>
</html>
"""
