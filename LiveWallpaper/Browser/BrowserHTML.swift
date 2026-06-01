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
  --bg:#0a0a0f;--surface:#111118;--surface2:#1a1a24;--surface3:#22222f;
  --border:#2a2a3a;--border2:#383850;--text:#e8e8f0;--muted:#6b6b8a;
  --accent:#7c5cfc;--accent2:#c084fc;--green:#34d399;--amber:#fbbf24;--red:#f87171;
}
html,body{height:100%;overflow:hidden;background:var(--bg);color:var(--text);font-family:'DM Sans',sans-serif;font-size:14px}
body{display:flex;flex-direction:column}
.app-body{display:flex;flex:1;min-height:0;overflow:hidden}

/* ── Sidebar ── */
.sidebar{width:196px;min-width:196px;background:var(--surface);border-right:1px solid var(--border);display:flex;flex-direction:column;padding:16px 0;-webkit-app-region:drag}
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
.sub-pill{display:flex;align-items:center;gap:6px;padding:8px 10px;border-radius:8px;background:linear-gradient(135deg,rgba(124,92,252,.15),rgba(192,132,252,.1));border:1px solid rgba(124,92,252,.3);cursor:pointer;margin:0 0 8px;-webkit-app-region:no-drag}
.sub-pill i{font-size:14px;color:var(--accent2)}
.sub-pill-text{font-size:11px;font-weight:500;color:var(--accent2);flex:1}
.sub-pill small{font-size:9px;color:var(--muted)}

/* ── Topbar ── */
.main{flex:1;display:flex;flex-direction:column;min-width:0;overflow:hidden}
.topbar{height:52px;background:var(--surface);border-bottom:1px solid var(--border);display:flex;align-items:center;padding:0 16px;gap:12px;flex-shrink:0;-webkit-app-region:drag}
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
.btn-primary:hover{background:#6a4de8}
.btn-gradient{background:linear-gradient(135deg,var(--accent),var(--accent2));color:#fff;border:none}
.btn-gradient:hover{opacity:.9}
.btn i{font-size:14px}

/* ── Content ── */
.content-area{flex:1;overflow:hidden;display:flex}
.browser-pane{flex:1;overflow-y:auto;padding:16px;min-width:0}
.tabs-row{display:flex;align-items:center;gap:3px;margin-bottom:14px;flex-wrap:wrap}
.tab{padding:6px 13px;border-radius:7px;cursor:pointer;font-size:12px;font-weight:500;color:var(--muted);border:1px solid transparent;transition:all .15s}
.tab:hover{color:var(--text)}
.tab.active{background:var(--surface2);color:var(--text);border-color:var(--border2)}
.spacer{flex:1}
.sort-select{background:var(--surface2);border:1px solid var(--border);color:var(--text);padding:6px 8px;border-radius:7px;font-family:'DM Sans',sans-serif;font-size:12px;cursor:pointer;outline:none}

/* ── Gallery ── */
.gallery{display:grid;grid-template-columns:repeat(auto-fill,minmax(190px,1fr));gap:12px}
.card{background:var(--surface);border:1px solid var(--border);border-radius:10px;overflow:hidden;cursor:pointer;transition:all .2s;position:relative}
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

/* ── My Videos view ── */
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

/* List view for scanned videos */
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
.pvbtn-apply:hover{background:#6a4de8}
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
.mc.play:hover{background:#6a4de8}
.mc.on{color:var(--accent)}
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
.pw-hero::before{content:'';position:absolute;inset:0;background:radial-gradient(ellipse at 50% 0%,rgba(124,92,252,.3),transparent 70%)}
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
.dropzone:hover,.dropzone.drag{border-color:var(--accent);background:rgba(124,92,252,.07)}
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
.sbtn:not(:disabled):hover{background:#6a4de8}
.sbtn:disabled{background:var(--surface3);color:var(--muted);cursor:not-allowed}

/* Empty state */
.empty{display:flex;flex-direction:column;align-items:center;justify-content:center;padding:50px 20px;text-align:center;gap:10px;color:var(--muted)}
.empty i{font-size:42px;color:var(--border2)}
.empty h3{font-size:13px;font-weight:600;color:var(--text)}
.empty p{font-size:12px;line-height:1.6;max-width:240px}

/* Toast */
.toast{position:fixed;bottom:80px;left:50%;transform:translateX(-50%) translateY(60px);background:var(--surface3);border:1px solid var(--border2);color:var(--text);padding:8px 18px;border-radius:8px;font-size:12px;font-weight:500;transition:transform .25s ease;z-index:999;pointer-events:none;white-space:nowrap}
.toast.show{transform:translateX(-50%) translateY(0)}
</style>
</head>
<body>

<div class="app-body">
  <!-- Sidebar -->
  <div class="sidebar">
    <div class="drag-handle"></div>
    <div class="logo"><span>BACKDROP</span><small>Live Wallpaper Studio</small></div>

    <div class="nav-section">
      <div class="nav-label">Browse</div>
      <div class="nav-item active" id="nav-browse" onclick="switchView('browse',this)"><i class="ti ti-layout-grid"></i> All Wallpapers</div>
      <div class="nav-item" id="nav-trending" onclick="switchView('trending',this)"><i class="ti ti-trending-up"></i> Trending</div>
      <div class="nav-item" id="nav-new" onclick="switchView('new',this)"><i class="ti ti-sparkles"></i> New</div>
    </div>

    <div class="nav-section" style="margin-top:8px">
      <div class="nav-label">Library</div>
      <div class="nav-item" id="nav-uploads" onclick="switchView('uploads',this)">
        <i class="ti ti-upload"></i> My Uploads <span class="nbadge" id="ucnt">0</span>
      </div>
      <div class="nav-item" id="nav-videos" onclick="switchView('videos',this)">
        <i class="ti ti-folder-search"></i> My Videos <span class="nbadge" id="vcnt">0</span>
      </div>
      <div class="nav-item" id="nav-saved" onclick="switchView('saved',this)"><i class="ti ti-heart"></i> Saved</div>
    </div>

    <div class="sidebar-bottom">
      <!-- Subscription pill — updated dynamically -->
      <div class="sub-pill" id="subPill" onclick="showPaywall()">
        <i class="ti ti-crown"></i>
        <div style="flex:1;min-width:0">
          <div class="sub-pill-text" id="subPillText">Upgrade to Pro</div>
          <small id="subPillSub">7-day free trial</small>
        </div>
      </div>
      <div class="nav-item" onclick="openUploadModal()"><i class="ti ti-upload"></i> Upload Video</div>
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
        <button class="btn btn-primary" onclick="openUploadModal()"><i class="ti ti-upload"></i> Upload</button>
      </div>
    </div>

    <div class="content-area">
      <div class="browser-pane" id="mainPane">

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

        <!-- My Uploads -->
        <div id="uploadsView" style="display:none">
          <div style="display:flex;align-items:center;justify-content:space-between;margin-bottom:14px">
            <span style="font-size:12px;color:var(--muted)" id="uploadsSub">Your uploaded wallpapers</span>
            <button class="btn btn-primary" onclick="openUploadModal()"><i class="ti ti-plus"></i> Add Video</button>
          </div>
          <div class="gallery" id="uploadsGallery"></div>
        </div>

        <!-- My Videos (folder scan) -->
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

        <!-- Saved -->
        <div id="savedView" style="display:none">
          <div class="empty"><i class="ti ti-heart"></i><h3>No saved wallpapers</h3><p>Heart any wallpaper to save it here.</p></div>
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
<div class="music-bar hidden" id="musicBar">
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
  <button class="btn btn-ghost" onclick="pickMusic()" style="margin-left:4px;padding:5px 8px"><i class="ti ti-plus"></i></button>
</div>

<!-- Paywall Modal -->
<div class="overlay" id="paywallModal">
  <div class="pw-box">
    <button class="pw-close-btn" onclick="closePaywall()"><i class="ti ti-x"></i></button>
    <div class="pw-hero">
      <div class="pw-icon"><i class="ti ti-crown"></i></div>
      <div class="pw-title">Backdrop Pro</div>
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

// ── Swift-driven callbacks ────────────────────────────────────────────────────

// Called by Swift on every page load AND after any upload add/remove/clear
function onUploadsChanged(uploads) {
  if (uploads !== undefined) userUploads = uploads;
  updateUploadsBadge();
  if (currentView === 'uploads') renderUploads();
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
    document.getElementById('submitBtn').textContent = 'Add to My Uploads';
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
  const acts=isUpload
    ?`<div class="card-actions">
        <button class="cab del" title="Delete" onclick="event.stopPropagation();deleteUpload('${c.id}')"><i class="ti ti-trash"></i></button>
      </div>`
    :`<div class="card-actions">
        <button class="cab" title="Save" onclick="event.stopPropagation();saveCard()"><i class="ti ti-heart"></i></button>
      </div>`;
  const vpath = c.fileURL || c.videoPath || '';
  const media = (isUpload && vpath)
    ? `<video src="${vpath}" muted loop playsinline preload="metadata"></video>`
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
  let list=PRESET;
  if(currentView==='trending') list=PRESET.filter(c=>c.badge==='trending');
  if(currentView==='new')      list=PRESET.filter(c=>c.badge==='new');
  filtered(list).forEach(c=>{
    const card=buildCard(c,false); grid.appendChild(card);
    requestAnimationFrame(()=>{ const cv=document.getElementById(`cv-${c.id}`); if(cv) drawThumb(cv,c.colors,320,180); });
  });
}

function renderUploads(){
  const grid=document.getElementById('uploadsGallery'); grid.innerHTML='';
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

// ── My Videos (folder scan) ───────────────────────────────────────────────────
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
    row.innerHTML=`
      <div class="vr-thumb"><canvas id="svcv-${v.id}" width="128" height="72"></canvas></div>
      <div class="vr-info">
        <div class="vr-title">${v.title}</div>
        <div class="vr-meta">
          <span><i class="ti ti-clock"></i>${v.duration}</span>
          <span><i class="ti ti-device-desktop"></i>${v.res}</span>
          <span><i class="ti ti-database"></i>${v.size}</span>
        </div>
      </div>
      <div class="vr-actions">
        <button class="cab" title="Apply" onclick="event.stopPropagation();applyScanned('${v.fileURL}')"><i class="ti ti-device-desktop"></i></button>
        <button class="cab del" title="Remove" onclick="event.stopPropagation();removeScanned('${v.id}')"><i class="ti ti-x"></i></button>
      </div>`;
    row.addEventListener('click',()=>openScannedPreview(v));
    list.appendChild(row);
    requestAnimationFrame(()=>{ const cv=document.getElementById(`svcv-${v.id}`); if(cv) drawThumb(cv,['#0a0a0f','#1a1a24','#22222f','#383850'],128,72); });
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
    <span><i class="ti ti-clock"></i>${c.dur||'—'}</span>`;
  document.getElementById('pvTags').innerHTML=(c.tags||[]).map(t=>`<span class="pv-tag">${t}</span>`).join('');
  const pvThumb=document.getElementById('pvThumb');
  if(isUpload && vpath){
    pvThumb.innerHTML=`<video id="pvVideo" src="${vpath}" muted loop playsinline style="width:100%;height:100%;object-fit:cover"></video>
      <div class="pv-play" onclick="togglePvVideo()"><i class="ti ti-player-play" id="pvPlayIcon"></i></div>`;
  } else {
    pvThumb.innerHTML=`<canvas id="pvCanvas" width="580" height="326"></canvas><div class="pv-play"><i class="ti ti-player-play"></i></div>`;
    requestAnimationFrame(()=>{ const cv=document.getElementById('pvCanvas'); if(cv) drawThumb(cv,c.colors||['#0a0a0f','#1a1a24','#2a2a3a','#7c5cfc'],580,326); });
  }
  document.getElementById('pvActions').innerHTML=isUpload
    ?`<button class="pvbtn pvbtn-apply" data-wtype="video" data-vpath="${vpath}" onclick="applyWallpaper(this)"><i class="ti ti-device-desktop"></i> Apply as Wallpaper</button>
       <button class="pvbtn pvbtn-del" onclick="deleteUpload('${c.id}');closePreview()"><i class="ti ti-trash"></i> Delete from Library</button>`
    :`<button class="pvbtn pvbtn-apply" data-wtype="${c.wtype}" data-vpath="" onclick="applyWallpaper(this)"><i class="ti ti-device-desktop"></i> Apply as Wallpaper</button>
       <button class="pvbtn pvbtn-sec" onclick="saveCard()"><i class="ti ti-heart"></i> Save</button>`;
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
  document.getElementById('pvThumb').innerHTML=`<video id="pvVideo" src="${v.fileURL}" muted loop playsinline style="width:100%;height:100%;object-fit:cover"></video>
    <div class="pv-play" onclick="togglePvVideo()"><i class="ti ti-player-play" id="pvPlayIcon"></i></div>`;
  document.getElementById('pvActions').innerHTML=`
    <button class="pvbtn pvbtn-apply" data-wtype="video" data-vpath="${v.fileURL}" onclick="applyWallpaper(this)"><i class="ti ti-device-desktop"></i> Apply as Wallpaper</button>
    <button class="pvbtn pvbtn-del" onclick="removeScanned('${v.id}');closePreview()"><i class="ti ti-x"></i> Remove from list</button>`;
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

function clearAllUploads(){
  if(!confirm('Remove all uploaded videos from My Uploads?\\n(Original files are NOT deleted from disk.)')) return;
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
  const titles={browse:'All Wallpapers',trending:'Trending',new:'New Releases',uploads:'My Uploads',videos:'My Videos',saved:'Saved'};
  document.getElementById('topbarTitle').textContent=titles[view]||'';
  const bv=['browse','trending','new'];
  document.getElementById('browseView').style.display=bv.includes(view)?'block':'none';
  document.getElementById('uploadsView').style.display=view==='uploads'?'block':'none';
  document.getElementById('videosView').style.display=view==='videos'?'block':'none';
  document.getElementById('savedView').style.display=view==='saved'?'block':'none';
  closePreview();
  if(bv.includes(view)) renderBrowse();
  if(view==='uploads') renderUploads();
  if(view==='videos') renderScannedVideos();
  // Update topbar right for uploads view (add clear button)
  const tbr=document.getElementById('topbarRight');
  if(view==='uploads'){
    tbr.innerHTML=`<button class="btn btn-ghost" style="color:var(--red)" onclick="clearAllUploads()"><i class="ti ti-trash"></i> Clear All</button>
      <button class="btn btn-primary" onclick="openUploadModal()"><i class="ti ti-upload"></i> Upload</button>`;
  } else {
    tbr.innerHTML=`<button class="btn btn-primary" onclick="openUploadModal()"><i class="ti ti-upload"></i> Upload</button>`;
  }
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
function togglePlay(){ isPlaying?pauseAudio():playAudio(); }
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
const dz=document.getElementById('dropZone');
dz.addEventListener('dragover',e=>{e.preventDefault();dz.classList.add('drag')});
dz.addEventListener('dragleave',()=>dz.classList.remove('drag'));
dz.addEventListener('drop',e=>{e.preventDefault();dz.classList.remove('drag');triggerUpload();});

let toastTimer;
function showToast(msg){ const t=document.getElementById('toast'); t.textContent=msg; t.classList.add('show'); clearTimeout(toastTimer); toastTimer=setTimeout(()=>t.classList.remove('show'),2400); }

renderBrowse();
// Note: userUploads and scannedVideos are populated by Swift callbacks after page load

</script>
</body>
</html>
"""
