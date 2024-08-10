/* eslint-disable no-unused-vars */
(() => {
	const x = e => new Promise(a => setTimeout(a, e)),
		D = e => {
			const a = GetEntityModel(e),
				o = GetHashKey('mp_m_freemode_01'),
				t = GetHashKey('mp_f_freemode_01');
			return a === o || a === t;
		},
		h = e => {
			const a = GetEntityModel(e),
				o = GetHashKey('mp_m_freemode_01');
			return a === o;
		};

	function f(e) {
		return {
			x: e[0],
			y: e[1],
			z: e[2],
		};
	}
	const ne = () => {
			const e = PlayerPedId(),
				a = GetEntityHealth(e),
				o = GetPedArmour(e);
			return [a, o];
		},
		ie = (e, a) => {
			const o = PlayerPedId();
			SetEntityHealth(o, e), SetPedArmour(o, a);
		};
	const O = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11],
		R = [0, 1, 2, 6, 7],
		F = ['noseWidth', 'nosePeakHigh', 'nosePeakSize', 'noseBoneHigh', 'nosePeakLowering', 'noseBoneTwist', 'eyeBrownHigh', 'eyeBrownForward', 'cheeksBoneHigh', 'cheeksBoneWidth', 'cheeksWidth', 'eyesOpening', 'lipsThickness', 'jawBoneWidth', 'jawBoneBackSize', 'chinBoneLowering', 'chinBoneLenght', 'chinBoneSize', 'chinHole', 'neckThickness'],
		b = ['blemishes', 'beard', 'eyebrows', 'ageing', 'makeUp', 'blush', 'complexion', 'sunDamage', 'lipstick', 'moleAndFreckles', 'chestHair', 'bodyBlemishes'],
		le = ['Green', 'Emerald', 'Light Blue', 'Ocean Blue', 'Light Brown', 'Dark Brown', 'Hazel', 'Dark Gray', 'Light Gray', 'Pink', 'Yellow', 'Purple', 'Blackout', 'Shades of Gray', 'Tequila Sunrise', 'Atomic', 'Warp', 'ECola', 'Space Ranger', 'Ying Yang', 'Bullseye', 'Lizard', 'Dragon', 'Extra Terrestrial', 'Goat', 'Smiley', 'Possessed', 'Demon', 'Infected', 'Alien', 'Undead', 'Zombie'],
		se = {
			male: [{
				id: 0,
				collection: 'mpbeach_overlays',
				overlay: 'FM_Hair_Fuzz',
			}, {
				id: 1,
				collection: 'multiplayer_overlays',
				overlay: 'NG_M_Hair_001',
			}, {
				id: 2,
				collection: 'multiplayer_overlays',
				overlay: 'NG_M_Hair_002',
			}, {
				id: 3,
				collection: 'multiplayer_overlays',
				overlay: 'NG_M_Hair_003',
			}, {
				id: 4,
				collection: 'multiplayer_overlays',
				overlay: 'NG_M_Hair_004',
			}, {
				id: 5,
				collection: 'multiplayer_overlays',
				overlay: 'NG_M_Hair_005',
			}, {
				id: 6,
				collection: 'multiplayer_overlays',
				overlay: 'NG_M_Hair_006',
			}, {
				id: 7,
				collection: 'multiplayer_overlays',
				overlay: 'NG_M_Hair_007',
			}, {
				id: 8,
				collection: 'multiplayer_overlays',
				overlay: 'NG_M_Hair_008',
			}, {
				id: 9,
				collection: 'multiplayer_overlays',
				overlay: 'NG_M_Hair_009',
			}, {
				id: 10,
				collection: 'multiplayer_overlays',
				overlay: 'NG_M_Hair_013',
			}, {
				id: 11,
				collection: 'multiplayer_overlays',
				overlay: 'NG_M_Hair_002',
			}, {
				id: 12,
				collection: 'multiplayer_overlays',
				overlay: 'NG_M_Hair_011',
			}, {
				id: 13,
				collection: 'multiplayer_overlays',
				overlay: 'NG_M_Hair_012',
			}, {
				id: 14,
				collection: 'multiplayer_overlays',
				overlay: 'NG_M_Hair_014',
			}, {
				id: 15,
				collection: 'multiplayer_overlays',
				overlay: 'NG_M_Hair_015',
			}, {
				id: 16,
				collection: 'multiplayer_overlays',
				overlay: 'NGBea_M_Hair_000',
			}, {
				id: 17,
				collection: 'multiplayer_overlays',
				overlay: 'NGBea_M_Hair_001',
			}, {
				id: 18,
				collection: 'multiplayer_overlays',
				overlay: 'NGBus_M_Hair_000',
			}, {
				id: 19,
				collection: 'multiplayer_overlays',
				overlay: 'NGBus_M_Hair_001',
			}, {
				id: 20,
				collection: 'multiplayer_overlays',
				overlay: 'NGHip_M_Hair_000',
			}, {
				id: 21,
				collection: 'multiplayer_overlays',
				overlay: 'NGHip_M_Hair_001',
			}, {
				id: 22,
				collection: 'multiplayer_overlays',
				overlay: 'NGInd_M_Hair_000',
			}, {
				id: 24,
				collection: 'mplowrider_overlays',
				overlay: 'LR_M_Hair_000',
			}, {
				id: 25,
				collection: 'mplowrider_overlays',
				overlay: 'LR_M_Hair_001',
			}, {
				id: 26,
				collection: 'mplowrider_overlays',
				overlay: 'LR_M_Hair_002',
			}, {
				id: 27,
				collection: 'mplowrider_overlays',
				overlay: 'LR_M_Hair_003',
			}, {
				id: 28,
				collection: 'mplowrider2_overlays',
				overlay: 'LR_M_Hair_004',
			}, {
				id: 29,
				collection: 'mplowrider2_overlays',
				overlay: 'LR_M_Hair_005',
			}, {
				id: 30,
				collection: 'mplowrider2_overlays',
				overlay: 'LR_M_Hair_006',
			}, {
				id: 31,
				collection: 'mpbiker_overlays',
				overlay: 'MP_Biker_Hair_000_M',
			}, {
				id: 32,
				collection: 'mpbiker_overlays',
				overlay: 'MP_Biker_Hair_001_M',
			}, {
				id: 33,
				collection: 'mpbiker_overlays',
				overlay: 'MP_Biker_Hair_002_M',
			}, {
				id: 34,
				collection: 'mpbiker_overlays',
				overlay: 'MP_Biker_Hair_003_M',
			}, {
				id: 35,
				collection: 'mpbiker_overlays',
				overlay: 'MP_Biker_Hair_004_M',
			}, {
				id: 36,
				collection: 'mpbiker_overlays',
				overlay: 'MP_Biker_Hair_005_M',
			}, {
				id: 72,
				collection: 'mpgunrunning_overlays',
				overlay: 'MP_Gunrunning_Hair_M_000_M',
			}, {
				id: 73,
				collection: 'mpgunrunning_overlays',
				overlay: 'MP_Gunrunning_Hair_M_001_M',
			}, {
				id: 74,
				collection: 'mpVinewood_overlays',
				overlay: 'MP_Vinewood_Hair_M_000_M',
			}],
			female: [{
				id: 0,
				collection: 'mpbeach_overlays',
				overlay: 'FM_Hair_Fuzz',
			}, {
				id: 1,
				collection: 'multiplayer_overlays',
				overlay: 'NG_F_Hair_001',
			}, {
				id: 2,
				collection: 'multiplayer_overlays',
				overlay: 'NG_F_Hair_002',
			}, {
				id: 3,
				collection: 'multiplayer_overlays',
				overlay: 'NG_F_Hair_003',
			}, {
				id: 4,
				collection: 'multiplayer_overlays',
				overlay: 'NG_F_Hair_004',
			}, {
				id: 5,
				collection: 'multiplayer_overlays',
				overlay: 'NG_F_Hair_005',
			}, {
				id: 6,
				collection: 'multiplayer_overlays',
				overlay: 'NG_F_Hair_006',
			}, {
				id: 7,
				collection: 'multiplayer_overlays',
				overlay: 'NG_F_Hair_007',
			}, {
				id: 8,
				collection: 'multiplayer_overlays',
				overlay: 'NG_F_Hair_008',
			}, {
				id: 9,
				collection: 'multiplayer_overlays',
				overlay: 'NG_F_Hair_009',
			}, {
				id: 10,
				collection: 'multiplayer_overlays',
				overlay: 'NG_F_Hair_010',
			}, {
				id: 11,
				collection: 'multiplayer_overlays',
				overlay: 'NG_F_Hair_011',
			}, {
				id: 12,
				collection: 'multiplayer_overlays',
				overlay: 'NG_F_Hair_012',
			}, {
				id: 13,
				collection: 'multiplayer_overlays',
				overlay: 'NG_F_Hair_013',
			}, {
				id: 14,
				collection: 'multiplayer_overlays',
				overlay: 'NG_M_Hair_014',
			}, {
				id: 15,
				collection: 'multiplayer_overlays',
				overlay: 'NG_M_Hair_015',
			}, {
				id: 16,
				collection: 'multiplayer_overlays',
				overlay: 'NGBea_F_Hair_000',
			}, {
				id: 17,
				collection: 'multiplayer_overlays',
				overlay: 'NGBea_F_Hair_001',
			}, {
				id: 18,
				collection: 'multiplayer_overlays',
				overlay: 'NG_F_Hair_007',
			}, {
				id: 19,
				collection: 'multiplayer_overlays',
				overlay: 'NGBus_F_Hair_000',
			}, {
				id: 20,
				collection: 'multiplayer_overlays',
				overlay: 'NGBus_F_Hair_001',
			}, {
				id: 21,
				collection: 'multiplayer_overlays',
				overlay: 'NGBea_F_Hair_001',
			}, {
				id: 22,
				collection: 'multiplayer_overlays',
				overlay: 'NGHip_F_Hair_000',
			}, {
				id: 23,
				collection: 'multiplayer_overlays',
				overlay: 'NGInd_F_Hair_000',
			}, {
				id: 25,
				collection: 'mplowrider_overlays',
				overlay: 'LR_F_Hair_000',
			}, {
				id: 26,
				collection: 'mplowrider_overlays',
				overlay: 'LR_F_Hair_001',
			}, {
				id: 27,
				collection: 'mplowrider_overlays',
				overlay: 'LR_F_Hair_002',
			}, {
				id: 28,
				collection: 'mplowrider2_overlays',
				overlay: 'LR_F_Hair_003',
			}, {
				id: 29,
				collection: 'mplowrider2_overlays',
				overlay: 'LR_F_Hair_003',
			}, {
				id: 30,
				collection: 'mplowrider2_overlays',
				overlay: 'LR_F_Hair_004',
			}, {
				id: 31,
				collection: 'mplowrider2_overlays',
				overlay: 'LR_F_Hair_006',
			}, {
				id: 32,
				collection: 'mpbiker_overlays',
				overlay: 'MP_Biker_Hair_000_F',
			}, {
				id: 33,
				collection: 'mpbiker_overlays',
				overlay: 'MP_Biker_Hair_001_F',
			}, {
				id: 34,
				collection: 'mpbiker_overlays',
				overlay: 'MP_Biker_Hair_002_F',
			}, {
				id: 35,
				collection: 'mpbiker_overlays',
				overlay: 'MP_Biker_Hair_003_F',
			}, {
				id: 36,
				collection: 'multiplayer_overlays',
				overlay: 'NG_F_Hair_003',
			}, {
				id: 37,
				collection: 'mpbiker_overlays',
				overlay: 'MP_Biker_Hair_006_F',
			}, {
				id: 38,
				collection: 'mpbiker_overlays',
				overlay: 'MP_Biker_Hair_004_F',
			}, {
				id: 76,
				collection: 'mpgunrunning_overlays',
				overlay: 'MP_Gunrunning_Hair_F_000_F',
			}, {
				id: 77,
				collection: 'mpgunrunning_overlays',
				overlay: 'MP_Gunrunning_Hair_F_001_F',
			}, {
				id: 78,
				collection: 'mpVinewood_overlays',
				overlay: 'MP_Vinewood_Hair_F_000_F',
			}],
		},
		ce = {
			ped: !0,
			headBlend: !0,
			faceFeatures: !0,
			headOverlays: !0,
			components: !0,
			props: !0,
			tattoos: !0,
		},
		W = {
			head: {
				animations: {
					on: {
						dict: 'mp_masks@standard_car@ds@',
						anim: 'put_on_mask',
						move: 51,
						duration: 600,
					},
					off: {
						dict: 'missheist_agency2ahelmet',
						anim: 'take_off_helmet_stand',
						move: 51,
						duration: 1200,
					},
				},
				props: {
					male: [
						[1, 0],
						// 12 - hat
						[12, 11],
					],
					female: [
						[1, 0],
						[12, 11],
					],
				},
			},
			body: {
				animations: {
					on: {
						dict: 'clothingtie',
						anim: 'try_tie_negative_a',
						move: 51,
						duration: 1200,
					},
					off: {
						dict: 'clothingtie',
						anim: 'try_tie_negative_a',
						move: 51,
						duration: 1200,
					},
				},
				props: {
					male: [
						[11, 178],
						[3, 15],
						[8, 15],
						[10, 0],
						[5, 0],
					],
					female: [
						[11, 15],
						[8, 14],
						[3, 15],
						[10, 0],
						[5, 0],
					],
				},
			},
			bottom: {
				animations: {
					on: {
						dict: 're@construction',
						anim: 'out_of_breath',
						move: 51,
						duration: 1300,
					},
					off: {
						dict: 're@construction',
						anim: 'out_of_breath',
						move: 51,
						duration: 1300,
					},
				},
				props: {
					male: [
						[4, 32],
						[6, 49],
					],
					female: [
						[4, 15],
						[6, 35],
					],
				},
			},
		};

	function de() {
		RegisterNuiCallbackType('appearance_get_locales'), RegisterNuiCallbackType('appearance_get_settings_and_data'), RegisterNuiCallbackType('appearance_set_camera'), RegisterNuiCallbackType('appearance_turn_around'), RegisterNuiCallbackType('appearance_rotate_camera'), RegisterNuiCallbackType('appearance_change_model'), RegisterNuiCallbackType('appearance_change_head_blend'), RegisterNuiCallbackType('appearance_change_face_feature'), RegisterNuiCallbackType('appearance_change_hair'), RegisterNuiCallbackType('appearance_change_head_overlay'), RegisterNuiCallbackType('appearance_change_eye_color'), RegisterNuiCallbackType('appearance_change_component'), RegisterNuiCallbackType('appearance_change_prop'), RegisterNuiCallbackType('appearance_apply_tattoo'), RegisterNuiCallbackType('appearance_preview_tattoo'), RegisterNuiCallbackType('appearance_delete_tattoo'), RegisterNuiCallbackType('appearance_wear_clothes'), RegisterNuiCallbackType('appearance_remove_clothes'), RegisterNuiCallbackType('appearance_save'), RegisterNuiCallbackType('appearance_exit'), on('__cfx_nui:appearance_get_locales', (e, a) => {
			const o = LoadResourceFile(GetCurrentResourceName(), `locales/${GetConvar('fivem-appearance:locale', 'en')}.json`);
			a(o);
		}), on('__cfx_nui:appearance_get_settings_and_data', (e, a) => {
			const o = _e(),
				t = J(),
				r = q();
			a({
				config: o,
				appearanceData: t,
				appearanceSettings: r,
			});
		}), on('__cfx_nui:appearance_set_camera', (e, a) => {
			a({}), Q(e);
		}), on('__cfx_nui:appearance_turn_around', (e, a) => {
			a({}), pe(PlayerPedId());
		}), on('__cfx_nui:appearance_rotate_camera', (e, a) => {
			a({}), ye(e);
		}), on('__cfx_nui:appearance_change_model', async (e, a) => {
			await w(e);
			const o = PlayerPedId();
			SetEntityHeading(PlayerPedId(), Y), SetEntityInvincible(o, !0), TaskStandStill(o, -1);
			const t = H(o),
				r = q();
			a({
				appearanceSettings: r,
				appearanceData: t,
			});
		}), on('__cfx_nui:appearance_change_component', (e, a) => {
			const o = PlayerPedId();
			B(o, e), a(Z(o, e.component_id));
		}), on('__cfx_nui:appearance_change_prop', (e, a) => {
			const o = PlayerPedId();
			L(o, e), a($(o, e.prop_id));
		}), on('__cfx_nui:appearance_change_head_blend', (e, a) => {
			a({}), M(PlayerPedId(), e);
		}), on('__cfx_nui:appearance_change_face_feature', (e, a) => {
			a({}), S(PlayerPedId(), e);
		}), on('__cfx_nui:appearance_change_head_overlay', (e, a) => {
			a({}), G(PlayerPedId(), e);
		}), on('__cfx_nui:appearance_change_hair', (e, a) => {
			a({}), T(PlayerPedId(), e);
		}), on('__cfx_nui:appearance_change_eye_color', (e, a) => {
			a({}), N(PlayerPedId(), e);
		}), on('__cfx_nui:appearance_apply_tattoo', (e, a) => {
			a({}), Pe(PlayerPedId(), e);
		}), on('__cfx_nui:appearance_preview_tattoo', (e, a) => {
			a({});
			const {
				data: o,
				tattoo: t,
			} = e;
			fe(PlayerPedId(), o, t);
		}), on('__cfx_nui:appearance_delete_tattoo', (e, a) => {
			a({}), ve(PlayerPedId(), e);
		}), on('__cfx_nui:appearance_wear_clothes', (e, a) => {
			a({});
			const {
				data: o,
				key: t,
			} = e;
			ue(o, t);
		}), on('__cfx_nui:appearance_remove_clothes', (e, a) => {
			a({}), me(e);
		}), on('__cfx_nui:appearance_save', (e, a) => {
			a({}), j(e);
		}), on('__cfx_nui:appearance_exit', (e, a) => {
			a({}), j();
		});
	}
	// eslint-disable-next-line prefer-const
	let Ne = global.exports,
		// eslint-disable-next-line prefer-const
		ge = {
			default: {
				coords: {
					x: 0,
					y: 2.2,
					z: 0.2,
				},
				point: {
					x: 0,
					y: 0,
					z: -0.05,
				},
			},
			head: {
				coords: {
					x: 0,
					y: 0.9,
					z: 0.65,
				},
				point: {
					x: 0,
					y: 0,
					z: 0.6,
				},
			},
			body: {
				coords: {
					x: 0,
					y: 1.2,
					z: 0.2,
				},
				point: {
					x: 0,
					y: 0,
					z: 0.2,
				},
			},
			bottom: {
				coords: {
					x: 0,
					y: 0.98,
					z: -0.7,
				},
				point: {
					x: 0,
					y: 0,
					z: -0.9,
				},
			},
		},
		// eslint-disable-next-line prefer-const
		ke = {
			default: {
				x: 1.5,
				y: -1,
			},
			head: {
				x: 0.7,
				y: -0.45,
			},
			body: {
				x: 1.2,
				y: -0.45,
			},
			bottom: {
				x: 0.7,
				y: -0.45,
			},
		},
		z, X, k, A, Y, m, E, C, g, he = {};

	function Ae() {
		const e = {
			hair: [],
			makeUp: [],
		};
		for (let a = 0; a < GetNumHairColors(); a++) e.hair.push(GetPedHairRgbColor(a));
		for (let a = 0; a < GetNumMakeupColors(); a++) e.makeUp.push(GetMakeupRgbColor(a));
		return e;
	}

	function J() {
		return k || (k = H(PlayerPedId())), k;
	}

	function Z(e, a) {
		const o = GetPedDrawableVariation(e, a);
		return {
			component_id: a,
			drawable: {
				min: 0,
				max: GetNumberOfPedDrawableVariations(e, a) - 1,
			},
			texture: {
				min: 0,
				max: GetNumberOfPedTextureVariations(e, a, o) - 1,
			},
		};
	}

	function $(e, a) {
		const o = GetPedPropIndex(e, a);
		return {
			prop_id: a,
			drawable: {
				min: -1,
				max: GetNumberOfPedPropDrawableVariations(e, a) - 1,
			},
			texture: {
				min: -1,
				max: GetNumberOfPedPropTextureVariations(e, a, o) - 1,
			},
		};
	}

	function q() {
		const e = PlayerPedId(),
			a = {
				model: {
					items: ae,
				},
			},
			o = {
				items: Ce,
			},
			t = O.map(u => Z(e, u)),
			r = R.map(u => $(e, u)),
			n = {
				shapeFirst: {
					min: 0,
					max: 45,
				},
				shapeSecond: {
					min: 0,
					max: 45,
				},
				skinFirst: {
					min: 0,
					max: 45,
				},
				skinSecond: {
					min: 0,
					max: 45,
				},
				shapeMix: {
					min: 0,
					max: 1,
					factor: 0.1,
				},
				skinMix: {
					min: 0,
					max: 1,
					factor: 0.1,
				},
			},
			l = F.reduce((u, y) => ({
				...u,
				[y]: {
					min: -1,
					max: 1,
					factor: 0.1,
				},
			}), {}),
			i = Ae(),
			s = {
				beard: i.hair,
				eyebrows: i.hair,
				chestHair: i.hair,
				makeUp: i.makeUp,
				blush: i.makeUp,
				lipstick: i.makeUp,
			},
			c = b.reduce((u, y, v) => {
				const P = {
					style: {
						min: 0,
						max: GetPedHeadOverlayNum(v) - 1,
					},
					opacity: {
						min: 0,
						max: 1,
						factor: 0.1,
					},
				};
				return s[y] && Object.assign(P, {
					color: {
						items: s[y],
					},
				}), {
					...u,
					[y]: P,
				};
			}, {}),
			_ = {
				style: {
					min: 0,
					max: GetNumberOfPedDrawableVariations(e, 2) - 1,
				},
				color: {
					items: i.hair,
				},
				highlight: {
					items: i.hair,
				},
			};
		return {
			ped: a,
			components: t,
			props: r,
			headBlend: n,
			faceFeatures: l,
			headOverlays: c,
			hair: _,
			eyeColor: {
				min: 0,
				max: 30,
			},
			tattoos: o,
		};
	}

	function _e() {
		return X;
	}

	function Q(e) {
		if (g) return;
		e !== 'current' && (E = e);
		const {
				coords: a,
				point: o,
			} = ge[E], t = C ? -1 : 1;
		if (m) {
			const r = f(GetOffsetFromEntityInWorldCoords(PlayerPedId(), a.x * t, a.y * t, a.z)),
				n = f(GetOffsetFromEntityInWorldCoords(PlayerPedId(), o.x, o.y, o.z)),
				l = CreateCameraWithParams('DEFAULT_SCRIPTED_CAMERA', r.x, r.y, r.z, 0, 0, 0, 50, !1, 0);
			PointCamAtCoord(l, n.x, n.y, n.z), SetCamActiveWithInterp(l, m, 1e3, 1, 1), g = !0;
			const i = setInterval(() => {
				!IsCamInterpolating(m) && IsCamActive(l) && (DestroyCam(m, !1), m = l, g = !1, clearInterval(i));
			}, 500);
		}
		else {
			const r = f(GetOffsetFromEntityInWorldCoords(PlayerPedId(), a.x, a.y, a.z)),
				n = f(GetOffsetFromEntityInWorldCoords(PlayerPedId(), o.x, o.y, o.z));
			m = CreateCameraWithParams('DEFAULT_SCRIPTED_CAMERA', r.x, r.y, r.z, 0, 0, 0, 50, !1, 0), PointCamAtCoord(m, n.x, n.y, n.z), SetCamActive(m, !0);
		}
	}
	async function ye(e) {
		if (g) return;
		let {
				// eslint-disable-next-line prefer-const
				coords: a,
				// eslint-disable-next-line prefer-const
				point: o,
			// eslint-disable-next-line prefer-const
			} = ge[E], t = ke[E], r, n = C ? -1 : 1;
		e === 'left' ? r = 1 : e === 'right' && (r = -1);
		const l = f(GetOffsetFromEntityInWorldCoords(PlayerPedId(), (a.x + t.x) * r * n, (a.y + t.y) * n, a.z)),
			i = f(GetOffsetFromEntityInWorldCoords(PlayerPedId(), o.x, o.y, o.z)),
			s = CreateCameraWithParams('DEFAULT_SCRIPTED_CAMERA', l.x, l.y, l.z, 0, 0, 0, 50, !1, 0);
		PointCamAtCoord(s, i.x, i.y, i.z), SetCamActiveWithInterp(s, m, 1e3, 1, 1), g = !0;
		const c = setInterval(() => {
			!IsCamInterpolating(m) && IsCamActive(s) && (DestroyCam(m, !1), m = s, g = !1, clearInterval(c));
		}, 500);
	}

	function pe(e) {
		C = !C;
		const a = OpenSequenceTask() ?? 0;
		a !== 0 && (TaskGoStraightToCoord(0, A.x, A.y, A.z, 8, -1, GetEntityHeading(e) - 180, 0.1), TaskStandStill(0, -1), CloseSequenceTask(a), ClearPedTasks(e), TaskPerformSequence(e, a), ClearSequenceTask(a));
	}
	async function ue(e, a) {
		const {
				animations: o,
				props: t,
			} = W[a], {
				dict: r,
				anim: n,
				move: l,
				duration: i,
			} = o.on, {
				male: s,
				female: c,
			} = t, {
				components: _,
			} = e, p = PlayerPedId(), u = h(p);
		for (RequestAnimDict(r); !HasAnimDictLoaded(r);) await x(0);
		if (u) {
			for (let y = 0; y < s.length; y++) {
				const [v] = s[y];
				for (let P = 0; P < _.length; P++) {
					const {
						component_id: V,
						drawable: U,
						texture: K,
					} = _[P];
					V === v && SetPedComponentVariation(p, v, U, K, 2);
				}
				buki(J());
			}
		}
		else {
			for (let y = 0; y < c.length; y++) {
				const [v] = c[y];
				for (let P = 0; P < _.length; P++) {
					const {
						component_id: V,
						drawable: U,
						texture: K,
					} = _[P];
					V === v && SetPedComponentVariation(p, v, U, K, 2);
				}
			}
		}
		buki(J());
		TaskPlayAnim(p, r, n, 3, 3, i, l, 0, !1, !1, !1);
	}
	async function me(e) {
		const {
				animations: a,
				props: o,
			} = W[e], {
				dict: t,
				anim: r,
				move: n,
				duration: l,
			} = a.off, {
				male: i,
				female: s,
			} = o, c = PlayerPedId(), _ = h(c);
		for (RequestAnimDict(t); !HasAnimDictLoaded(t);) await x(0);
		if (_) {
			for (let p = 0; p < i.length; p++) {
				const [u, y] = i[p];
				if (u != 12) {
					SetPedComponentVariation(c, u, y, 0, 2);
				}
				else {
					SetPedPropIndex(c, 0, y, 0, true);
				}
			}
		}
		else {
			for (let p = 0; p < s.length; p++) {
				const [u, y] = s[p];
				if (u != 12) {
					SetPedComponentVariation(c, u, y, 0, 2);
				}
				else {
					SetPedPropIndex(c, 0, y, 0, true);
				}
			}
		}
		TaskPlayAnim(c, t, r, 3, 3, l, n, 0, !1, !1, !1);
	}
	// eslint-disable-next-line no-var
	var ee = () => he,
		I = (e, a) => {
			he = a;
			const o = h(e);
			ClearPedDecorations(e);
			for (const t in a) {
				for (let r = 0; r < a[t].length; r++) {
					const {
							collection: n,
							hashFemale: l,
							hashMale: i,
						} = a[t][r], s = o ? i : l;
					AddPedDecorationFromHashes(e, GetHashKey(n), GetHashKey(s));
				}
			}
		},
		Pe = (e, a) => {
			const o = h(e);
			ClearPedDecorations(e);
			for (const t in a) {
				for (let r = 0; r < a[t].length; r++) {
					const {
							collection: n,
							hashFemale: l,
							hashMale: i,
						} = a[t][r], s = o ? i : l;
					AddPedDecorationFromHashes(e, GetHashKey(n), GetHashKey(s));
				}
			}
		},
		ve = (e, a) => {
			const o = h(e);
			ClearPedDecorations(e);
			for (const t in a) {
				for (let r = 0; r < a[t].length; r++) {
					const {
							collection: n,
							hashFemale: l,
							hashMale: i,
						} = a[t][r], s = o ? i : l;
					AddPedDecorationFromHashes(e, GetHashKey(n), GetHashKey(s));
				}
			}
		},
		fe = (e, a, o) => {
			const t = h(e),
				{
					collection: r,
					hashFemale: n,
					hashMale: l,
				} = o,
				i = t ? l : n;
			ClearPedDecorations(e), AddPedDecorationFromHashes(e, GetHashKey(r), GetHashKey(i));
			for (const s in a) {
				for (let c = 0; c < a[s].length; c++) {
					const {
						name: _,
						collection: p,
						hashFemale: u,
						hashMale: y,
					} = a[s][c];
					if (o.name !== _) {
						const v = t ? y : u;
						AddPedDecorationFromHashes(e, GetHashKey(p), GetHashKey(v));
					}
				}
			}
		};

	function Ee(e, a = ce) {
		const o = PlayerPedId();
		k = H(o), z = e, a.automaticFade = Boolean(Number(GetConvar('fivem-appearance:automaticFade', '1'))), X = a, A = f(GetEntityCoords(o, !0)), Y = GetEntityHeading(o), C = !1, g = !1, Q('default'), SetNuiFocus(!0, !0), SetNuiFocusKeepInput(!1), RenderScriptCams(!0, !1, 0, !0, !0), DisplayRadar(!1), SetEntityInvincible(o, !0), TaskStandStill(o, -1);
		const t = {
			type: 'appearance_display',
			payload: {},
		};
		SendNuiMessage(JSON.stringify(t));
	}

	function j(e) {
		RenderScriptCams(!1, !1, 0, !0, !0), DestroyCam(m, !1), DisplayRadar(!0), SetNuiFocus(!1, !1);
		const a = PlayerPedId();
		ClearPedTasksImmediately(a), SetEntityInvincible(a, !1);
		const o = {
			type: 'appearance_hide',
			payload: {},
		};
		if (SendNuiMessage(JSON.stringify(o)), !e) {oe(J());}
		else {
			const {
				tattoos: t,
			} = e;
			I(a, t);
		}
		z && z(e), z = null, X = null, k = null, A = null, m = null, E = null, C = null, g = null;
	}

	function Ie(e) {
		e === GetCurrentResourceName() && (SetNuiFocus(!1, !1), SetNuiFocusKeepInput(!1));
	}

	function De() {
		de(), on('onResourceStop', Ie), Ne('startPlayerCustomization', Ee);
	}
	const He = {
		loadModule: De,
	};
	// eslint-disable-next-line no-var
	var d = global.exports,
		Oe = '0x2746bd9d88c5c5d0',
		Re = Boolean(Number(GetConvar('fivem-appearance:automaticFade', '1'))),
		Ce = JSON.parse(LoadResourceFile(GetCurrentResourceName(), 'files/tattoos.json')),
		ae = JSON.parse(LoadResourceFile(GetCurrentResourceName(), 'files/peds.json')),
		we = ae.reduce((e, a) => ({
			...e,
			[GetHashKey(a)]: a,
		}), {});

	function xe(e) {
		return we[GetEntityModel(e)];
	}

	function Fe(e) {
		const a = [];
		return O.forEach(o => {
			a.push({
				component_id: o,
				drawable: GetPedDrawableVariation(e, o),
				texture: GetPedTextureVariation(e, o),
			});
		}), a;
	}

	function be(e) {
		const a = [];
		return R.forEach(o => {
			a.push({
				prop_id: o,
				drawable: GetPedPropIndex(e, o),
				texture: GetPedPropTextureIndex(e, o),
			});
		}), a;
	}

	function Me(e) {
		const a = new ArrayBuffer(80);
		global.Citizen.invokeNative(Oe, e, new Uint32Array(a));
		const {
				0: o,
				2: t,
				6: r,
				8: n,
			} = new Uint32Array(a), {
				0: l,
				2: i,
			} = new Float32Array(a, 48), s = parseFloat(l.toFixed(1)), c = parseFloat(i.toFixed(1));
		return {
			shapeFirst: o,
			shapeSecond: t,
			skinFirst: r,
			skinSecond: n,
			shapeMix: s,
			skinMix: c,
		};
	}

	function Se(e) {
		return F.reduce((o, t, r) => {
			const n = parseFloat(GetPedFaceFeature(e, r).toFixed(1));
			return {
				...o,
				[t]: n,
			};
		}, {});
	}

	function Ge(e) {
		return b.reduce((o, t, r) => {
			// eslint-disable-next-line prefer-const
			let [, n, , l, , i] = GetPedHeadOverlayData(e, r), s = n !== 255, c = s ? n : 0, _ = s ? parseFloat(i.toFixed(1)) : 0;
			return {
				...o,
				[t]: {
					style: c,
					opacity: _,
					color: l,
				},
			};
		}, {});
	}

	function Te(e) {
		return {
			style: GetPedDrawableVariation(e, 2),
			color: GetPedHairColor(e),
			highlight: GetPedHairHighlightColor(e),
		};
	}

	function Be(e) {
		// eslint-disable-next-line prefer-const
		let a = GetEntityModel(e),
			o;
		return a === GetHashKey('mp_m_freemode_01') ? o = 'male' : a === GetHashKey('mp_f_freemode_01') && (o = 'female'), o;
	}

	function Le(e, a) {
		const o = Be(e);
		return o ? se[o].find(r => r.id === a) : void 0;
	}

	function H(e) {
		const a = GetPedEyeColor(e);
		return {
			model: xe(e) || 'mp_m_freemode_01',
			headBlend: Me(e),
			faceFeatures: Se(e),
			headOverlays: Ge(e),
			components: Fe(e),
			props: be(e),
			hair: Te(e),
			eyeColor: a < le.length ? a : 0,
			tattoos: ee(),
		};
	}
	async function w(e) {
		if (!e || !IsModelInCdimage(e)) return;
		for (RequestModel(e); !HasModelLoaded(e);) await x(0);
		const [a, o] = ne();
		SetPlayerModel(PlayerId(), e), SetModelAsNoLongerNeeded(e);
		const t = PlayerPedId();
		D(t) && (SetPedDefaultComponentVariation(t), SetPedHeadBlendData(t, 0, 0, 0, 0, 0, 0, 0, 0, 0, !1)), ie(a, o);
	}

	function M(e, a) {
		if (!a) return;
		const {
			shapeFirst: o,
			shapeSecond: t,
			shapeMix: r,
			skinFirst: n,
			skinSecond: l,
			skinMix: i,
		} = a;
		D(e) && SetPedHeadBlendData(e, o, t, 0, n, l, 0, r, i, 0, !1);
	}

	function S(e, a) {
		!a || F.forEach((o, t) => {
			const r = a[o];
			SetPedFaceFeature(e, t, r);
		});
	}

	function G(e, a) {
		!a || b.forEach((o, t) => {
			const r = a[o];
			if (SetPedHeadOverlay(e, t, r.style, r.opacity), r.color || r.color === 0) {
				let n = 1;
				({
					blush: !0,
					lipstick: !0,
					makeUp: !0,
				})[o] && (n = 2), SetPedHeadOverlayColor(e, t, n, r.color, r.color);
			}
		});
	}

	function T(e, a) {
		if (!a) return;
		const {
			style: o,
			color: t,
			highlight: r,
		} = a;
		if (SetPedComponentVariation(e, 2, o, 0, 0), SetPedHairColor(e, t, r), Re) {
			const n = Le(e, o);
			if (ClearPedDecorations(e), n) {
				const {
					collection: l,
					overlay: i,
				} = n;
				AddPedDecorationFromHashes(e, GetHashKey(l), GetHashKey(i));
			}
		}
	}

	function N(e, a) {
		!a || SetPedEyeColor(e, a);
	}

	function B(e, a) {
		if (!a) return;
		const {
			component_id: o,
			drawable: t,
			texture: r,
		} = a;
		({
			0: !0,
			2: !0,
		})[o] && D(e) || SetPedComponentVariation(e, o, t, r, 0);
	}

	function te(e, a) {
		!a || a.forEach(o => B(e, o));
	}

	function L(e, a) {
		if (!a) return;
		const {
			prop_id: o,
			drawable: t,
			texture: r,
		} = a;
		t === -1 ? ClearPedProp(e, o) : SetPedPropIndex(e, o, t, r, !1);
	}

	function re(e, a) {
		!a || a.forEach(o => L(e, o));
	}
	async function oe(e) {
		if (!e) return;
		const {
			model: a,
			components: o,
			props: t,
			headBlend: r,
			faceFeatures: n,
			headOverlays: l,
			hair: i,
			eyeColor: s,
			tattoos: c,
		} = e;
		await w(a);
		const _ = PlayerPedId();
		te(_, o), re(_, t), r && M(_, r), n && S(_, n), l && G(_, l), i && T(_, i), s && N(_, s), c && I(_, c);
	}


	// ADDON FIX FOR REMOVE HAT
	function serbia(e, a) {
		if (!a) return;
		const {
			prop_id: o,
			drawable: t,
			texture: r,
		} = a;
		if (o == 0) {
			t === -1 ? ClearPedProp(e, o) : SetPedPropIndex(e, o, t, r, !1);
		}
	}

	function kk(e, a) {
		!a || a.forEach(o => serbia(e, o));
	}

	async function buki(e) {
		if (!e) return;
		const {
			model: a,
			components: o,
			props: t,
			headBlend: r,
			faceFeatures: n,
			headOverlays: l,
			hair: i,
			eyeColor: s,
			tattoos: c,
		} = e;
		kk(PlayerPedId(), t);
	}

	// END

	function ze(e, a) {
		if (!a) return;
		const {
			components: o,
			props: t,
			headBlend: r,
			faceFeatures: n,
			headOverlays: l,
			hair: i,
			eyeColor: s,
			tattoos: c,
		} = a;
		te(e, o), re(e, t), r && M(e, r), n && S(e, n), l && G(e, l), i && T(e, i), s && N(e, s), c && I(e, c);
	}
	He.loadModule(), d('getPedModel', xe), d('getPedComponents', Fe), d('getPedProps', be), d('getPedHeadBlend', Me), d('getPedFaceFeatures', Se), d('getPedHeadOverlays', Ge), d('getPedHair', Te), d('getPedTattoos', ee), d('getPedAppearance', H), d('setPlayerModel', w), d('setPedHeadBlend', M), d('setPedFaceFeatures', S), d('setPedHeadOverlays', G), d('setPedHair', T), d('setPedEyeColor', N), d('setPedComponent', B), d('setPedComponents', te), d('setPedProp', L), d('setPedProps', re), d('setPedTattoos', I), d('setPlayerAppearance', oe), d('setPedAppearance', ze);
})();
