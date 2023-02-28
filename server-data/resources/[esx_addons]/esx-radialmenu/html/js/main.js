'use strict';

var ESXRadialMenu = null;
var toggleConfig = false;
var keybindConfig = false;
$(document).ready(function(){
    window.addEventListener('message', function(event){
        switch (event.data.action) {
            case "ui":
                toggleConfig = event.data.toggle;
                keybindConfig = event.data.keybind;
                if (event.data.radial) {
                    createMenu(event.data.items)
                    ESXRadialMenu.open();
                } else {
                    ESXRadialMenu.close(true);
                }
                if (toggleConfig === false){
                     $(document).on('keyup', function(e) {
                         if(e.key == keybindConfig | e.key === keybindConfig.toLowerCase()){
                             ESXRadialMenu.close();
                         }
                     });
                 } else {
                    $(document).on('keydown', function(e) {
                        switch(e.key) {
                            case keybindConfig:
                                ESXRadialMenu.close();
                                break;
                        }
                    });
                 }
        }
    });
});
function createMenu(items) {
    ESXRadialMenu = new RadialMenu({
        parent      : document.body,
        size        : 375,
        menuItems   : items,
        onClick     : function(item) {
            if (item.shouldClose) {
                ESXRadialMenu.close(true);
            }
            
            if (item.items == null && item.shouldClose != null) {
                $.post('https://esx-radialmenu/selectItem', JSON.stringify({
                    itemData: item
                }))
            }
        }
    });
}

// Close on escape pressed
$(document).on('keydown', function(e) {
    switch(e.key) {
        case "Escape":
            ESXRadialMenu.close();
            break;
    }
});
