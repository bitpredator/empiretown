!function(e) {
	const t = {};
	function r(n) {
		if (t[n]) return t[n].exports;
		const o = t[n] = { i: n, l: !1, exports: {} };
		return e[n].call(o.exports, o, o.exports, r), o.l = !0, o.exports;
	// eslint-disable-next-line no-shadow
	} r.m = e, r.c = t, r.d = function(e, t, n) {
		r.o(e, t) || Object.defineProperty(e, t, { enumerable: !0, get: n });
	// eslint-disable-next-line no-shadow
	}, r.r = function(e) {
		typeof Symbol != 'undefined' && Symbol.toStringTag && Object.defineProperty(e, Symbol.toStringTag, { value: 'Module' }), Object.defineProperty(e, '__esModule', { value: !0 });
	// eslint-disable-next-line no-shadow
	}, r.t = function(e, t) {
		if (1 & t && (e = r(e)), 8 & t) return e; if (4 & t && typeof e == 'object' && e && e.__esModule) return e;
		const n = Object.create(null); if (r.r(n), Object.defineProperty(n, 'default', { enumerable: !0, value: e }), 2 & t && typeof e != 'string') {
			for (const o in e) {
				// eslint-disable-next-line no-shadow
				r.d(n, o, function(t) {
					return e[t];
				}.bind(null, o));
			}
		}
		return n;
	// eslint-disable-next-line no-shadow
	}, r.n = function(e) {
		// eslint-disable-next-line no-shadow
		const t = e && e.__esModule ? function() { return e.default; } : function() {
		 return e;
		}; return r.d(t, 'a', t), t;
	// eslint-disable-next-line no-shadow
	}, r.o = function(e, t) { return Object.prototype.hasOwnProperty.call(e, t); }, r.p = '', r(r.s = 0);
}([function(e, t, r) {
	// eslint-disable-next-line no-shadow
	(function(e) {
		// eslint-disable-next-line no-shadow
		const t = e.exports;
		RegisterNuiCallbackType('screenshot_created');
		// eslint-disable-next-line no-shadow
		const r = {}; let n = 0;
		// eslint-disable-next-line no-shadow
		function o(e) {
			// eslint-disable-next-line no-shadow
			const t = n.toString();
			return r[t] = { cb: e }, n++, t;
		// eslint-disable-next-line no-shadow
		} on('__cfx_nui:screenshot_created', (e, t) => {
			t(!0), void 0 !== e.id && r[e.id] && (r[e.id].cb(e.data), delete r[e.id]);
		// eslint-disable-next-line no-shadow
		}), t('requestScreenshot', (e, t) => { const r = void 0 !== t ? e : { encoding: 'jpg' }, n = void 0 !== t ? t : e; r.resultURL = null, r.targetField = null, r.targetURL = `http://${GetCurrentResourceName()}/screenshot_created`, r.correlation = o(n), SendNuiMessage(JSON.stringify({ request: r })); }), t('requestScreenshotUpload', (e, t, r, n) => {
			const i = void 0 !== n ? r : { headers: {}, encoding: 'jpg' }, u = void 0 !== n ? n : r; i.targetURL = e, i.targetField = t, i.resultURL = `http://${GetCurrentResourceName()}/screenshot_created`, i.correlation = o(u), SendNuiMessage(JSON.stringify({ request: i }));
		// eslint-disable-next-line no-shadow, no-empty-function
		}), onNet('screenshot_basic:requestScreenshot', (e, t) => { e.encoding = e.encoding || 'jpg', e.targetURL = `http://${GetCurrentServerEndpoint()}${t}`, e.targetField = 'file', e.resultURL = null, e.correlation = o(() => { }), SendNuiMessage(JSON.stringify({ request: e })); });
	}).call(this, r(1));
// eslint-disable-next-line no-unused-vars
}, function(e, t) {
	// eslint-disable-next-line max-statements-per-line
	let r; r = function() { return this; }(); try { r = r || new Function('return this')(); }
	// eslint-disable-next-line no-unused-vars, no-shadow
	catch (e) { typeof window == 'object' && (r = window); } e.exports = r;
}]);