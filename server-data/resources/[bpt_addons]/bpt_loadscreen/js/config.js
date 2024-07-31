// eslint-disable-next-line no-unused-vars
const config =
{
	// Base
	BASE: {

		color: {
			background: 'linear-gradient(45deg, rgba(0,0,0,1) 0%, rgba(85,85,85,1) 100%)',
			servername:
            [
            	// eslint-disable-next-line no-inline-comments
            	'rgba(250,250,250,1)', // main color
            	// eslint-disable-next-line no-inline-comments
            	'rgba(66,66,66,1)', // change color
            ],

			cursor_dot: 'rgba(255,255,255,1)',
			cursor_ring: 'rgba(255,255,255,1)',
			logs: 'rgba(255, 255, 255, 0.46)',
			music_text: 'rgba(117,117,117,1)',
			music_icons: 'rgba(255,255,255,1)',
			nav_icon: 'rgba(255,255,255,1)',
			nav_background:
            [
            	// eslint-disable-next-line no-inline-comments
            	'rgba(9,9,12,1)', // front
            	// eslint-disable-next-line no-inline-comments
            	'rgba(20,21,26,0.6)', // back
            ],
			nav_underline: 'rgba(117,117,117,1)',
			nav_text:
            [
            	// eslint-disable-next-line no-inline-comments
            	'rgba(255,255,255,0.6)', // normal
            	// eslint-disable-next-line no-inline-comments
            	'rgba(255,255,255,1)', // highlight
            ],

			loadingbar_background:
            [
            	// eslint-disable-next-line no-inline-comments
            	'rgba(66,66,66,1)', // Pre-Map
            	// eslint-disable-next-line no-inline-comments
            	'rgba(88,88,88,1)', // Map
            	// eslint-disable-next-line no-inline-comments
            	'rgba(110,110,110,1)', // Post-Map
            	// eslint-disable-next-line no-inline-comments
            	'rgba(132,132,132,1)', // Session
            ],

			loadingbar_text:
            [
            	// eslint-disable-next-line no-inline-comments
            	'rgba(66,66,66,1)', // Pre-Map
            	// eslint-disable-next-line no-inline-comments
            	'rgba(88,88,88,1)', // Map
            	// eslint-disable-next-line no-inline-comments
            	'rgba(110,110,110,1)', // Post-Map
            	// eslint-disable-next-line no-inline-comments
            	'rgba(132,132,132,1)', // Session
            ],

			waves:
            [
            	// eslint-disable-next-line no-inline-comments
            	'rgba(66,66,66,0.7)', // back
            	'rgba(88,88,88,0.5)',
            	'rgba(110,110,110,0.3)',
            	// eslint-disable-next-line no-inline-comments
            	'rgba(132,132,132,1)', // front
            ],
		},

	},

	// Server Name
	SVN: {
		enable: true,
		phrases:
         [
         	'EMPIRETOWN',
         	'EMP',
         	'BPT-CORE',
         	'BPT-FRAMEWORK',
         ],
		chars: 'EMPIRETOWN EMP BPT-CORE BPT-FRAMEWORK',
		changeTime: 15,
		changePhrasesTime: 30,
	},

	// Logs
	LOG: {
		enable: false,
	},

	// Music
	MUSIC: {
		enable: true,
		// eslint-disable-next-line no-inline-comments
		music: // YT ID
         [
         	'RLr59M_Zvlg',
         ],
		Volume: 20,
		TextPrefix: 'EMP:',
	},
};