# Changelog

<!-- ⚠⚠ Please follow the format provided ⚠⚠ -->
<!-- Always use "1." at the start instead of "2. " or "X. " as GitHub will auto renumber everything. -->
<!-- Use the following format below -->
<!--  1. [Changed Area] Title of changes - @github username  -->

<!-- Version 1.0.0 -->
1. [.github\PULL_REQUEST_TEMPLATE.md]: update the pull request template file @bitpredator
2. [esx_property\config.lua]: improves code formatting @bitpredator
   [esx_property\client\html\copy.html]: remove jquery @bitpredator
   [esx_property\client\main.lua]: add copy to clipboard to /getoffset @bitpredator
   [esx_property\locales\en.lua & it.lua]: corrected typos @bitpredator
   [esx_property\server\main.lua]: correction of lint errors @bitpredator
   [esx_property\config.lua]: correction of lint errors @bitpredator
3. [esx_license\server\main.lua]: Replaced print in esx_license:addLicense @bitpredator
   [esx_license\fxmanifest.lua]: Update fxmanifest.lua to version 1.0.0 @bitpredator
   [esx_license\README.md]: update reference links in README.md @bitpredator
   [esx_license\LICENSE]: updates the copyright reference year @bitpredator
4. [pma-voice/voice-ui/pnpm-lock.yaml]: chore: (deps-dev) bump url-parse + bump minimatch + bump terser @bitpredator
   [pma-voice/client/module/phone.lua]: fix(phone): fix getting re-added to radios if perfectly hit
   [pma-voice/client/init/main.lua]: fix(radio): fix oversight with function call
   [pma-voice/workflows/dependency-review.yml]: chore(deps): bump actions/checkout from 3 to 4 @bitpredator
   [pma-voice/voice-ui/pnpm-lock.yaml]: chore(deps-dev): bump follow-redirects in /voice-ui @bitpredator
5. [.github\PULL_REQUEST_TEMPLATE.md]: fix: corrected pull request form template @bitpredator
6. [voice-ui/pnpm-lock.yaml]: chore: (deps-dev) bump url-parse + bump minimatch + bump terser @bitpredator
   [client/module/phone.lua]: fix(phone): fix getting re-added to radios if perfectly hit
   [client/init/main.lua]: fix(radio): fix oversight with function call
   [workflows/dependency-review.yml]: chore(deps): bump actions/checkout from 3 to 4
   [voice-ui/pnpm-lock.yaml]: chore(deps-dev): bump follow-redirects in /voice-ui
   [voice-ui/pnpm-lock.yaml]: chore(deps-dev): bump browserify-sign from 4.2.1 to 4.2.2 in /voice-ui
7. [npwd + es_extended]: chore: removed support for npwd_crypto @bitpredator
8. [ox_lib]: chore: ox_lib update to version 3.12.0 @bitpredator
9. [esx_addons]: chore: replace esx_drivingschooljob with esx_dmvschool @bitpredator
10. [SQL]: chore: update database @bitpredator
11. [maps]: delete: remove maps verpi_driving_school @bitpredator
12. [ox_inventory]: chore: remove store dmvshool @bitpredator
13. [BasicItem]: chore: code cleanup and fixes @bitpredator
14. [BOBHunt]: refactor: code cleaning, various corrections to the code as well as license updates @bitpredator
15. [BOBHunt]: refactor: supports all translations natively @bitpredator
16. [SQL]: chore: removed white strings inside some sql @bitpredator
17. [esx_addoninventory]: delete: removed the .editorconfig file @bitpredator
18. [ox_inventory]: fix: corrected the weight of the items @bitpredator
19. [esx_identity]: chore: update the code version and improve the formatting @bitpredator
20. [esx_addons]: fix: replace bpt_realisticvehicle with esx_RealisticVehicleFailure to fix repair issues @bitpredator
21. [bpt_streetfight]: chore: clean up the code @bitpredator
22. [bpt_farmer]: chore: clean up the code @bitpredator
23. [bpt_teleport]: chore: clean up the code @bitpredator
24. [mythic_notify]: fix: removed unused variables @bitpredator
25. [esx_status]: refactor: remove jquery + Remove some shitty lines @bitpredator
26. [esx_status/server]: fix: unused argument @bitpredator
27. [esx_addoninventory]: chore: check for nil society @bitpredator
28. [npwd]: chore: npwd update to version 1.8.6 @bitpredator
29. [bpt_deliveries]: chore: clean up the code + fix readme & fxmanifest @bitpredator
30. [esx-radialmenu]: chore:  fix lint error + clean up the code @bitpredator
31. [esx-qalle-jail]: fix: fix lint error @bitpredator
32. [esx_multicaracter]: fix: fix lint error @bitpredator
33. [esx_dmvschool]: fix: fix lint error @bitpredator
34. [oxmysql]: chore: update to version 2.7.6 @bitpredator
35. [esx-radio] fix: fixed No such export addChannelCheck in resource pma-voice @bitpredator
36. [bpt_vehicletax]: chore: clean up the code @bitpredator
37. [jsfour-idcard]: fix: value assigned to variable ESX is overwritten @bitpredator
38. [es_extended]: refactor/fix: cleanup, remove useless code, formatting + 
fix lint error: unused argument last; accessing undefined variable Invoke; unused variable targetCoords @bitpredator
39. [esx_taxijob]: refactor: Remove cb, use playerdata obj + fix formatting @bitpredator
40. [workflows]: delete: remove stale.yml + greetings.yml @bitpredator
41. [ox_inventory\data\shops.lua]: chore: the possibility of purchasing the radio has been added @bitpredator
    [ox_inventory\data\stashes.lua]: fix: removed the inventory for the taxi job as it was included in the esx_taxijob resource @bitpredator
42. [esx_joblisting]: refactor: correct the good year for the license + varius fix @bitpredator
43. [EUP]: delete: removed package [EUP] @bitpredator
44. [bpt_ammujob]: refactor: bpt_ammujob inventory implementation @bitpredator
45. [SQL]: fix: es_extended.sql "addon_inventory" syntax error @bitpredator
46. [npwd]: fix: Warning: could not find @bitpredator
47. [server.cfg]: fix: Couldn't find resource @bitpredator
48. fix: No such export getSharedObject in resource es_extended @bitpredator
49. [bpt_bakerjob]: refactor: bpt_bakerjob inventory implementation @bitpredator
50. [bpt_ballasjob]: refactor: bpt_ballasjob inventory implementation @bitpredator
51. [bpt_ballasjob]: feat: bpt_ballasjob\locales\en.lua @bitpredator
52. [bpt_ammujob]: Fixed the problem that prevented the creation of invoices @bitpredator
53. [bpt_bakerjob]: Fixed the problem that prevented the creation of invoices @bitpredator
54. [bpt_ballasjob]: Fixed the problem that prevented the creation of invoices @bitpredator
55. [bpt_crafting]: Refactor: created support for translations natively through local files @bitpredator
56. [bpt_deliveries]: feat + chore: updated readme file + creation of Italian translation @bitpredator
57. [bpt_dustman]: refactor: bpt_dustman inventory implementation @bitpredator
58. [bpt_farmer]: refactor: support for translations through local files @bitpredator
59. [bpt_fishermanjob]: refactor: bpt_fishermanjob inventory implementation @bitpredator
60. [bpt_hud]: chore: push for version 1.0.0 @bitpredator
61. [bpt_importjob]: refactor: bpt_importjob inventory implementation @bitpredator
62. [bpt_loadscreen]: chore: bpt_loadscreen improves code formatting @bitpredator
63. [bpt_lumberjack]: fix: bpt_lumberjack fixed typos and removed unused code @bitpredator
64. [bpt_crafting]: fix: correct ingredients to use @bitpredator