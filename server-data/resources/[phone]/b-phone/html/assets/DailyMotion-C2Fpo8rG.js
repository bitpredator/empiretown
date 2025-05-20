/* eslint-disable no-unused-vars */
import { g as P, r as React, u as utils, p as patterns } from './index-C9YnOZvp.js';

function mergeModules(target, sources) {
	for (const src of sources) {
		if (typeof src !== 'string' && !Array.isArray(src)) {
			for (const key in src) {
				if (key !== 'default' && !(key in target)) {
					const desc = Object.getOwnPropertyDescriptor(src, key);
					if (desc) {
						Object.defineProperty(target, key, desc.get ? desc : {
							enumerable: true,
							get: () => src[key],
						});
					}
				}
			}
		}
	}
	return Object.freeze(Object.defineProperty(target, Symbol.toStringTag, { value: 'Module' }));
}

class DailyMotionPlayer extends React.Component {
	constructor(props) {
		super(props);
		this.callPlayer = utils.callPlayer;
		this.container = null;

		this.ref = this.ref.bind(this);
		this.play = this.play.bind(this);
		this.pause = this.pause.bind(this);
		this.mute = this.mute.bind(this);
		this.unmute = this.unmute.bind(this);
		this.seekTo = this.seekTo.bind(this);
		this.setVolume = this.setVolume.bind(this);
		this.getDuration = this.getDuration.bind(this);
		this.getCurrentTime = this.getCurrentTime.bind(this);
		this.getSecondsLoaded = this.getSecondsLoaded.bind(this);
		this.onDurationChange = this.onDurationChange.bind(this);
	}

	componentDidMount() {
		if (this.props.onMount) {
			this.props.onMount(this);
		}
	}

	ref(element) {
		this.container = element;
	}

	onDurationChange() {
		const duration = this.getDuration();
		if (this.props.onDuration) {
			this.props.onDuration(duration);
		}
	}

	load(url) {
		const { controls, config, onError, playing, muted } = this.props;
		const match = url.match(patterns.MATCH_URL_DAILYMOTION);
		if (!match) return;

		const videoId = match[1];

		if (this.player) {
			this.player.load(videoId, {
				start: utils.parseStartTime(url),
				autoplay: playing,
			});
			return;
		}

		utils.getSDK('https://api.dmcdn.net/all.js', 'DM', 'dmAsyncInit', sdk => sdk.player)
			.then(DM => {
				if (!this.container) return;

				this.player = new DM.player(this.container, {
					width: '100%',
					height: '100%',
					video: videoId,
					params: {
						controls,
						autoplay: playing,
						mute: muted,
						start: utils.parseStartTime(url),
						origin: window.location.origin,
						...config.params,
					},
					events: {
						apiready: this.props.onReady,
						seeked: () => this.props.onSeek(this.player.currentTime),
						video_end: this.props.onEnded,
						durationchange: this.onDurationChange,
						pause: this.props.onPause,
						playing: this.props.onPlay,
						waiting: this.props.onBuffer,
						error: onError,
					},
				});
			})
			.catch(onError);
	}

	play() {
		this.callPlayer('play');
	}

	pause() {
		this.callPlayer('pause');
	}

	mute() {
		this.callPlayer('setMuted', true);
	}

	unmute() {
		this.callPlayer('setMuted', false);
	}

	seekTo(seconds, playAfterSeek = true) {
		this.callPlayer('seek', seconds);
		if (!playAfterSeek) {
			this.pause();
		}
	}

	setVolume(volume) {
		this.callPlayer('setVolume', volume);
	}

	getDuration() {
		return this.player?.duration ?? null;
	}

	getCurrentTime() {
		return this.player?.currentTime ?? null;
	}

	getSecondsLoaded() {
		return this.player?.bufferedTime ?? null;
	}

	render() {
		const style = {
			width: '100%',
			height: '100%',
			display: this.props.display,
		};

		return React.createElement(
			'div',
			{ style },
			React.createElement('div', { ref: this.ref }),
		);
	}
}

DailyMotionPlayer.displayName = 'DailyMotion';
DailyMotionPlayer.canPlay = patterns.canPlay.dailymotion;
DailyMotionPlayer.loopOnEnded = true;

const wrapped = mergeModules({ __proto__: null, default: DailyMotionPlayer }, [DailyMotionPlayer]);
export { wrapped as D };
