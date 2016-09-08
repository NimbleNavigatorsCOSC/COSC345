var c;
var ctx;
var buttons = [];
var userPosition = {lat: 0, lng: 0};

/**
 * Create a new button object and draw it to the screen.
 * 
 * @param {number} x - X coordinate of top left corner.
 * @param {number} y - Y coordinate of top left corner.
 * @param {number} w - Width of button, in pixels.
 * @param {number} h - Height of button, in pixels.
 * @param {string} c - Color of the button. as a hex value.
 * @param {string} sc - Color of the buttons shadow. as a hex value.
 * @param {function} onClickFunction - The function to be called when the button is clicked.
 * @param {object} data - An object containing all the parameters of the function as data fields.
 * @returns {undefined}
 */
function createButton(x, y, w, h, c, sc, onClickFunction, data) {
    createButtonObject(x, y, w, h, onClickFunction, data);
    drawButton(x, y, w, h, c, sc);
}

/**
 * Create a new button object no associated visual element.
 * 
 * @param {number} x - X coordinate of top left corner.
 * @param {number} y - Y coordinate of top left corner.
 * @param {number} w - Width of button, in pixels.
 * @param {number} h - Height of button, in pixels.
 * @param {function} onClickFunction - The function to be called when the button is clicked.
 * @param {object} data - An object containing all the parameters of the function as data fields.
 * @returns {createButtonObject.createdButton} - Return a reference to the created button object.
 */
function createButtonObject(x, y, w, h, onClickFunction, data) {
    var createdButton = {
        xLocation: x,
        yLocation: y,
        width: w,
        height: h,
        onClickFunction: function () {
            onClickFunction(data);
        },
        data: data
    };

    buttons[x + "," + y] = createdButton;
    return createdButton;
}

/**
 * Check if a mouse click is within the bounds of a button.
 * 
 * @param {number} x - X coordinate of mouse click.
 * @param {number} y - Y coordinate of mouse click.
 * @param {number} objX - X coordinate of the buttons top left corner.
 * @param {number} objY - Y coordinate of the buttons top left corner.
 * @param {number} objW - Width of button, in pixels.
 * @param {number} objH - Height of button, in pixels.
 * @returns {Boolean} - True if the mouse click was within the the bounds of a button.
 */
function withinBounds(x, y, objX, objY, objW, objH) {
    if ((objX < x && objY < y) && (objW + objX > x && objY + objH > y)) {
        return true;
    }
    return false;
}

/**
 * Return a list of all buttons that are currently active.
 * 
 * @returns {Array|buttons|button1} - An array of all the buttons currently on screen.
 */
function getButtons() {
    return buttons;
}

/**
 * Clear all currently active buttons.
 * 
 * @returns {undefined}
 */
function clearButtons() {
    buttons = [];
}

/**
 * Return the x, y coordinates of a mouse click.
 * 
 * @param {type} evt
 * @returns {onClick.EmulatorAnonym$0} - Return an object with teh x and y coordinates of the mouse click as data fields.
 */
function onClick(evt) {
    var rect = c.getBoundingClientRect(), root = document.documentElement;

    var mouseX = evt.clientX - rect.left - root.scrollLeft;
    var mouseY = evt.clientY - rect.top - root.scrollTop;
    return {
        x: mouseX,
        y: mouseY
    };
}

/**
 * Draw a rectangle.
 * 
 * @param {number} x - x coordinate of rectangles top left corner.
 * @param {number} y - y coordinate of rectangles top left corner.
 * @param {number} w - width of rectangle.
 * @param {number} h - height of rectangle.
 * @param {String} c - Color of the rectangle, as a hex value.
 * @returns {undefined}
 */
function drawRect(x, y, w, h, c) {
    ctx.fillStyle = c;
    ctx.fillRect(x, y, w, h);
}

/**
 * Draw a line between two points.
 * 
 * @param {number} x1 - x coordinate of lines start point.
 * @param {number} y1 - y coordinate of lines start point.
 * @param {number} x2 - x coordinate of lines end point.
 * @param {number} y2 - y coordinate of lines end point.
 * @returns {undefined}
 */
function drawLine(x1, y1, x2, y2) {
    ctx.moveTo(x1, y1);
    ctx.lineTo(x2, y2);
    ctx.stroke();
}

/**
 * Draw a circle.
 * 
 * @param {number} x - x coordinate of circles center.
 * @param {number} y - y coordinate of circles center.
 * @param {number} r - radius of the circle.
 * @returns {undefined}
 */
function drawCircle(x, y, r) {
    ctx.beginPath();
    ctx.arc(x, y, r, 0, 2 * Math.PI);
    ctx.stroke();
}

/**
 * Draw a string of text.
 * 
 * @param {number} x - x coordinate of text.
 * @param {number} y - y coordinate of text.
 * @param {string} text - String to be displayed.
 * @param {string} c - Color of text as a hex value.
 * @param {number} s - Point size of text.
 * @param {string} font - Desired font.
 * @returns {undefined}
 */
function drawText(x, y, text, c, s, font) {
    ctx.fillStyle = c;
    ctx.font = s + "px " + font;
    ctx.fillText(text, x, y);
}

/**
 * Draw an image to screen.
 * 
 * @param {number} x - x coordinate of images top left corner.
 * @param {number} y - y coordinate of images top left corner.
 * @param {Image} img - The image to be drawn.
 * @returns {undefined}
 */
function drawImage(x, y, img) {
    ctx.drawImage(img, x, y);
}

/**
 * Draw a button with a standard style.
 * 
 * @param {number} x - X coordinate of top left corner.
 * @param {number} y - Y coordinate of top left corner.
 * @param {number} w - Width of button, in pixels.
 * @param {number} h - Height of button, in pixels.
 * @param {string} colour - Color of the button. as a hex value.
 * @param {string} shadowColour - Color of the buttons shadow. as a hex value.
 * @returns {undefined}
 */
function drawButton(x, y, w, h, colour, shadowColour) {
    drawRect(x + 5, y + 5, w, h, shadowColour);
    drawRect(x, y, w, h, colour);
}

/**
 * Clear the canvas.
 * 
 * @returns {undefined}
 */
function clear() {
    ctx.clearRect(0, 0, 320, 320);
}

/**
 * Draw a static map with a marker on the given location to the canvas.
 * 
 * @param {object} obj - An object holding the longitude and latitude of a location as data fields.
 * @returns {undefined}
 */
function mapTest(obj) {
    var google_tile = "http://maps.google.com/maps/api/staticmap?sensor=false&center=" + obj.lat + "," + obj.lng + "&zoom=16&size=320x320" + "&markers=color:red%7Clabel:C%7C" + obj.lat + "," + obj.long;
    var imageObj = new Image();
    imageObj.src = google_tile;
    imageObj.onload = function () {
        ctx.drawImage(imageObj, 0, 0);
    };
}

/**
 * Create a dynamic map with a route draw between the userLocation and the given location.
 * 
 * @param {type} targetLocation - An objecting holding the longitude and latitude of a location as data fields.
 * @returns {undefined}
 */
function initDirection(targetLocation) {

    // Create a map object and specify the DOM element for display.
    document.getElementById('map').style.display = 'block';
    var map = new google.maps.Map(document.getElementById('map'), {
        center: {lat: userPosition.lat, lng: userPosition.lng},
        scrollwheel: true,
        zoom: 12
    });

    var directionsDisplay = new google.maps.DirectionsRenderer({
        map: map
    });

    var request = {
        destination: targetLocation,
        origin: userPosition,
        travelMode: 'WALKING'
    };

    var directionsService = new google.maps.DirectionsService();
    directionsService.route(request, function (response, status) {
        if (status === 'OK') {
            directionsDisplay.setDirections(response);
        }
    });
}

/**
 * Update the userPosition object with the browsers geolocation capabilities.
 * 
 * @returns {undefined}
 */
function updateLocation() {
    var message;
    try {
        if (navigator.geolocation) {
            navigator.geolocation.getCurrentPosition(function (position) {
                userPosition = {lat: position.coords.latitude, lng: position.coords.longitude};
            });
        } else {

            throw "Geolocation Not Enabled.";

        }
    } catch (err) {
        message.innerHTML = "geolocation not enabled";
    }
}

/**
 * Return the distance to a destination in meters.
 * 
 * @param {Object} destination - An object holding the latitude and longitude of a destination as data fields.
 * @returns {Number}
 */
function getDistance(destination) {
    return google.maps.geometry.spherical.computeDistanceBetween(new google.maps.LatLng(userPosition.lat, userPosition.lng, true), new google.maps.LatLng(destination.lat, destination.lng, true));
}

/**
 * Open a given URL in a new tab.
 * 
 * @param {string} url - A URL to be opened in a new tab by the browser.
 * @returns {undefined}
 */
function webRedirect(url) {
    window.open(url);
}

/**
 * Get canvas and mapDiv elements, added button click listener.
 * 
 * @returns {undefined}
 */
function init() {
    c = document.getElementById("myCanvas");
    document.getElementById('map').style.display = 'none';
    ctx = c.getContext("2d");
    c.addEventListener('click', function (evt) {
        mousePos = onClick(evt);
        mousePosG = mousePos.x;
        checkInput(mousePos.x, mousePos.y);
    }, false);

}

init();
