/*--------------------------------------------------------------------------

    ActionMenu 
    Created by WolfKnight
    Additional help from lowheartrate, TheStonedTurtle, and Briglair.  

--------------------------------------------------------------------------*/
var weapons = false
$( function() {
    // Adds all of the correct button actions 
    init();

    // Gets the actionmenu div container 
    var actionContainer = $( "#actionmenu" );

    // Listens for NUI messages from Lua 
    window.addEventListener( 'message', function( event ) {
        var item = event.data;
        
        // Show the menu 
        if ( item.showmenu ) {
            ResetMenu()
			weapons = item.weapons
            actionContainer.show();
        }

        // Hide the menu 
        if ( item.hidemenu ) {
            actionContainer.hide(); 
        }
    } );
} )

// Hides all div elements that contain a data-parent, in
// other words, hide all buttons in submenus. 
function ResetMenu() {
    $( "div" ).each( function( i, obj ) {
        var element = $( this );

        if ( element.attr( "data-parent" ) ) {
            element.hide();
        } else {
            element.show();
        }
    } );
}

function parseWeapons(weapons) {
	$('#weapons').html('');
	$('#invsubmenus').html('')
	var shit = document.querySelectorAll('[data-spawn="weapon"]')
	for (var i = 0; i < shit.length; i++) {
	  var item = shit[i]; 
	  item.remove();
	}
	$('#exitbutton').remove()
	weps = JSON.parse(weapons)
	$('#weapons').append('<button class="menuoption" data-action="weapon-putaway"><b>Store Weapon</b></button>')
	jQuery.each(weps, function(i, val) {
		$('#weapons').append('<button class="menuoption" data-sub="'+i+'">'+val.name+'</button>')
		$('#actionmenu').append('<div id="'+i+'" data-parent="mainmenu" style="display: none;">'+
			'<button class="menuoption" data-action="wepmenu-info-'+i+'">View Info</button>'+
			'<button class="menuoption" data-action="wepmenu-info">Equip</button>'+
		'</div>')
	});
	
	$('#actionmenu').append('<button id="exitbutton" class="menuoption" data-action="exit">Exit</button>')
	init()
}

function parseItems(items) {
	items = JSON.parse(items)
}

// Configures every button click to use its data-action, or data-sub
// to open a submenu. 
function init() {
    // Loops through every button that has the class of "menuoption"
    $( ".menuoption" ).each( function( i, obj ) {

        // If the button has a data-action, then we set it up so when it is 
        // pressed, we send the data to the lua side. 
        if ( $( this ).attr( "data-action" ) ) {
            $( this ).click( function() { 
                var data = $( this ).data( "action" ); 
				console.log(data)
				spleet = data.split("-")
				if (spleet[1] == 'info') {
					weps = JSON.parse(weapons)
					//console.log(weps[parseInt(spleet[2], 0)])
					sendData( "weaponInfo", weps[parseInt(spleet[2], 0)]); 
				} else {
					sendData( "ButtonClick", data ); 
				}
            } )
        }

        // If the button has a data-sub, then we set it up so when it is 
        // pressed, we show the submenu buttons, and hide all of the others.
        if ( $( this ).attr( "data-sub" ) ) {
            $( this ).click( function() {
                var menu = $( this ).data( "sub" );
                var element = $( "#" + menu ); 
                element.show();
                $( this ).parent().hide();  
				if (menu == 'weapons') {
					parseWeapons(weapons);
				}
            } )
        }
    } );
}

// Send data to lua for processing.
function sendData( name, data ) {
    $.post( "http://fsn_apartments/" + name, JSON.stringify( data ), function( datab ) {
        if ( datab != "ok" ) {
            console.log( datab );
        }            
    } );
}