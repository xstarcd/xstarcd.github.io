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
    //if ($('#tree').ztree_toc != undefined) {
    if ($.fn.zTree) {
        $('#tree').ztree_toc({
            documment_selector: '.markdown-body',
            is_auto_number:true,
            is_expand_all:false,
            is_posion_top:true,
            is_highlight_selected_line:false,
            debug:false,
            highlight_on_scroll:false,
            _header_nodes:[],
            ztreeStyle: {
                width:'260px',
                overflow: 'auto',
                position: 'fixed',
                'z-index': 2147483647,
                border: '0px none',
                left: '0px',
                'top': '15px',
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
        $('#tree').css('display','none');
        $('#WikiToc').css({width:'70px',height:'25px'});
        $('#ShowHideToc')[0].innerText="ShowTOC";
    }else{
        $('#tree').css('display','block');
        $('#WikiToc').css({width:'260px',height:'98%'});
        $('#ShowHideToc')[0].innerText="HideTOC";
    }
    return null;
}

function loadWikiTocCore(){
    WikiTocStyle={
        width:'260px',
        height:'98%',
        //overflow: 'auto',
        position: 'fixed',
        'z-index': 2147483647,
        border: '0px none',
        left: '0px',
        'top': '0px',
        'background-color': 'yellowgreen',
        //bottom: '0px',
    };
    theURL='http://xstarcd.github.io/wiki/files/ztreetoc/';
    theCSS=theURL + 'zTreeStyle.css';
    theJS1=theURL + 'jquery.ztree.all-3.5.min.js';
    theJS2=theURL + 'jquery.ztree_toc.js';
    thread=$("<div id='WikiToc' style='width:30%;'><span id='ShowHideToc' style='cursor:pointer' onclick='javasript:hidetoc()'>HideTOC</span><ul id='tree' class='ztree' style='width:100%'></ul></div>'");
    getCSS(theCSS);
    $('body').append(thread);
    $('#WikiToc').css(WikiTocStyle);
    $.getScript(theJS1);
    $.getScript(theJS2);
}
var timeId = 0;
$(document).ready(function(){
    if($('.wiki').length >0){
        loadWikiTocCore();
        timeId=setTimeout(genTree,1000); 
    }
});
//javascript:$('head').append("<script src='http://xstarcd.github.io/wiki/files/ztreetoc/ldztreegithub.js'><script>");void(0);

