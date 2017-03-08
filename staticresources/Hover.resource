.HoverPopup {
    position: relative;
    z-index: 0;
    }
 
.HoverPopup:hover {
    background-color: #FFFDFD;
    Text-decoration: none;
    z-index: 50;
    }
 
.HoverPopup div {
    position: absolute;
    visibility: hidden;
    }
 
.HoverPopup:hover div {
    visibility: visible;
    top: 20px;
    left: 0px;
    border: 1px solid black;
    background-color: #FFFDFD;
    padding: 10px;
    color: black;
    Text-decoration: none;
    white-space: pre;
    }