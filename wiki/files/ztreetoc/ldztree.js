// Auther: YuanXing
// Create: 2015-07-04
var documment_selector='';
theURL='//xstarcd.github.io/wiki/files/ztreetoc/';
if (window.location.protocol == 'file:'){
    theURL='http:'+theURL;
}else{
    theURL=window.location.protocol+theURL;
}
function getCSS(url) {
    var tag = '<link rel="stylesheet" href="' + url + '" />';
    $('head').append(tag);
}
function insertCSS(url) {
    $.get(url, function(res) {
        var tag = '<style>' + res + '</style>';
        $('body').append(tag);
    });
}
function genTree() {
    if(timeId){
        clearTimeout(timeId);
        timeId=0;
    }
    if ($.fn.zTree) {
        $('#tree').ztree_toc({
            //documment_selector: '.wiki',
            documment_selector: documment_selector,
            is_auto_number:false,
            is_expand_all:true,
            is_posion_top:true,
            is_highlight_selected_line:false,
            debug:false,
            highlight_on_scroll:false,
            _header_nodes:[],
            ztreeStyle: {
                width:'250px',
                overflow: 'auto',
                position: 'fixed',
                'z-index': 2147483647,
                border: '0px none',
                left: '0px',
                'top': '18px',
                //bottom: '0px',
                // height:'100px'
            },
        });
    }else{
        timeId=setTimeout(genTree,1000); 
    }
}
function hidetoc(){
    if($('#tree').css('display') == 'block'){
        $('#tree').hide();
        $('#WikiToc').css({width:'70px',height:'22px'});
        $('#ShowHideToc')[0].innerHTML="ShowTOC";
    }else{
        $('#tree').show();
        $('#WikiToc').css({width:'260px',height:'98%'});
        $('#ShowHideToc')[0].innerHTML="HideTOC";
    }
    return null;
}
function loadWikiTocCore(){
    WikiTocStyle={
        width:'260px',
        height:'100%',
        //overflow: 'auto',
        position: 'fixed',
        'z-index': 2147483647,
        border: '0px none',
        left: '0px',
        'top': '0px',
        //'background-color': 'yellowgreen',
        'background-color': 'whitesmoke',
        //bottom: '0px',
    };
    theCSS=theURL + 'zTreeStyle.css';
    theJS1=theURL + 'jquery.ztree.all-3.5.min.js';
    theJS2=theURL + 'jquery.ztree_toc.js';
    thread=$("<div id='WikiToc' style='width:30%;'><span id='ShowHideToc' style='cursor:pointer' onclick='javasript:hidetoc()'>HideTOC</span><ul id='tree' class='ztree' style='width:100%'></ul></div>'");
    getCSS(theCSS);
    if($('WikiToc')) $('#WikiToc').remove();
    $('body').append(thread);
    //$('#tree').empty();
    $('#WikiToc').css(WikiTocStyle);
    $.getScript(theJS1);
    $.getScript(theJS2);
}
var timeId = 0;
$(document).ready(function(){
    if($('.wiki').length >0) {
        documment_selector='.wiki';
    }else if($('.markdown-body').length >0) {
        documment_selector='.markdown-body';
    }else if($('#main').length >0) {
        documment_selector='#main'; 
    }

    if(documment_selector != ''){
        loadWikiTocCore();
        timeId=setTimeout(genTree,1000); 
    }
});
//javascript:$('head').append("<script src='http://xstarcd.github.io/wiki/files/ztreetoc/ldztree.js'><script>");void(0);

