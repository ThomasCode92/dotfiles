// ==UserScript==
// @name         SketchyBar YouTube bridge
// @namespace    sketchybar
// @version      1.0
// @description  Report the current YouTube video to the local SketchyBar helper.
// @match        https://www.youtube.com/watch*
// @match        https://www.youtube.com/shorts/*
// @match        https://music.youtube.com/watch*
// @grant        GM_xmlhttpRequest
// @connect      127.0.0.1
// @run-at       document-idle
// ==/UserScript==

(function () {
  'use strict';

  const endpoint = 'http://127.0.0.1:8765/youtube';

  function videoId() {
    const fromQuery = new URLSearchParams(location.search).get('v');
    if (fromQuery && /^[A-Za-z0-9_-]{11}$/.test(fromQuery)) return fromQuery;
    const fromPath = location.pathname.match(/^\/(?:shorts|embed)\/([A-Za-z0-9_-]{11})/);
    return fromPath ? fromPath[1] : '';
  }

  function text(selectors) {
    for (const selector of selectors) {
      const node = document.querySelector(selector);
      const value = node && node.textContent ? node.textContent.trim() : '';
      if (value) return value;
    }
    return '';
  }

  function title() {
    return text([
      'h1 yt-formatted-string',
      'yt-formatted-string#title',
      '#video-title',
    ]).replace(/\s*-\s*YouTube\s*$/, '').trim() || document.title;
  }

  function channel() {
    return text([
      '#channel-name ytd-channel-name #text',
      'ytd-video-owner-renderer #channel-name #text',
      'ytd-channel-name #text',
      '#owner-name a',
    ]);
  }

  function playing() {
    const video = document.querySelector('video');
    return Boolean(video && !video.paused && !video.ended && video.readyState > 2);
  }

  function report() {
    const id = videoId();
    if (!id) return;

    const payload = {
      videoId: id,
      title: title().slice(0, 200),
      channel: channel().slice(0, 100),
      playing: playing(),
    };
    GM_xmlhttpRequest({
      method: 'POST',
      url: endpoint,
      headers: { 'Content-Type': 'application/json' },
      data: JSON.stringify(payload),
    });
  }

  document.addEventListener('yt-navigate-finish', report);
  document.addEventListener('play', report, true);
  document.addEventListener('pause', report, true);
  document.addEventListener('visibilitychange', report);
  window.addEventListener('focus', report);
  window.setInterval(report, 2000);
  report();
})();
