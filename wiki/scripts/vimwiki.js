var kwiki = {
    getCSS: function(url) {
        var tag = '<link rel="stylesheet" href="' + url + '" />';
        $('body').append(tag);
    },
    insertCSS: function(url) {
        $.get(url, function(res) {
            var tag = '<style>' + res + '</stle>';
            $('body').append(tag);
        });
    },
    insertScript: function(url, bottle) {
        var tag = '<script src=' + url + '></script>';
        if (!bottle) bottle = 'head';
        $(bottle).append(tag);
    },

    loadCmt: function(provider) {
        if ($('#no-comment').length > 0) return;
        var thread, extraCSS, theJS;

        var kwiki_identifier = 'wiki' + window.location.pathname.replace(/\//g, '_').replace('index.html', '')
            //.replace('.html', '');
        var kwiki_title = $(document).attr("title");
        var kwiki_url = 'http://w.gdu.me' + window.location.pathname.replace('index.html', '');
        //var kwiki_url = 'http://xstarcd.gdu.me' + window.location.pathname.replace('index.html', '');

        if (provider == 'disqus') {
            //disqus
            window.disqus_iframe_css = vimwiki_rootpath+'styles/disqus_iframe.css';
            window.disqus_identifier = kwiki_identifier || undefined;
            thread = $('<div id="disqus_thread">');
            extraCSS = vimwiki_rootpath+'styles/disqus.css';
            theJS = 'http://longber.disqus.com/embed.js';
        } else if (provider == 'duoshuo') {
            //duoshuo
            window.duoshuoQuery = {short_name:"xstar"};
            //thread = $('<div class="ds-thread">');
            thread = $('<div class="ds-thread" data-thread-key="'+kwiki_identifier+'" data-title="'+kwiki_title+'" data-url="'+kwiki_url+'">');
            //thread = $('<div class="ds-thread" data-thread-key="'+kwiki_identifier+'" data-title="'+kwiki_title+'">');
            theJS = 'http://static.duoshuo.com/embed.js';
        } else {
            return;
        }

        $('#main').append(thread);
        var win = $(window);
        function load() {
            if (win.scrollTop() + win.height() > thread.offset().top - 250) {
                if (extraCSS) kwiki.getCSS(extraCSS);
                $.getScript(theJS);
                win.unbind('scroll');
            }
        }
        win.bind('scroll', load);
        load();
    }
};

$(document).ready(function() {
    if (window.innerWidth >= 460) {
        var toggler = $('<div class="toggler" title="点击展开/收起，Shift+Z 隐藏或打开">目录</div>'),
        toc = $('.toc');
        toc.wrap('<div class="tocWrap">');

        $('.tocWrap').prepend(toggler)
        .delay(500)
        .fadeTo(500, '0.25')
        .hover(function() {
            $(this).stop().fadeTo(300, '0.9');
        }, function() {
            $(this).stop().fadeTo(300, '0.25');
        });

        $('html').keypress(function(e) {
            if (e.shiftKey && (e.charCode || e.keyCode) == '90') {
                e.preventDefault();
                $('div.tocWrap').toggle(200);
            }
        });

        toggler.click(function() {
            $('div.toc').slideToggle(300);
        });
    }

    //外链在新窗口（或标签）打开
    $("a[href^='http']").each(function(){
        if (window.location.host == '' || this.href.indexOf(window.location.host) == -1)
            $(this).attr({target: '_blank', title: this.href });
    });

    //点击内链,滚动到所在位置
    $('a[href^=#][href!=#]').click(function() {
        var target = document.getElementById(this.hash.slice(1));
        if (!target) return;
        var targetOffset = $(target).offset().top;
        $('html,body').animate({scrollTop: targetOffset}, 400);
        return false;
    });

    //lesser
    $('div.lesser .hd').click(function() { $(this).next().slideToggle(300); });

    //代码高亮
    if (window.location.hostname==''){
        //var loadpath=vimwiki_rootpath;
        //var loadpath='http://alexgorbatchev.com/pub/sh/current/';
        var loadpath='http://cdn.bootcss.com/SyntaxHighlighter/3.0.83/';
    }else{
        //var loadpath='http://alexgorbatchev.com/pub/sh/current/';
        var loadpath='http://cdn.bootcss.com/SyntaxHighlighter/3.0.83/';
    }
    function path() {
        var args = arguments,
        result = [];
        for(var i = 0; i < args.length; i++)
          result.push(args[i].replace('@', loadpath+'scripts/'));
        return result;
    }
    var syntaxHighlight = function() {
        //kwiki.getCSS(loadpath+'styles/shThemeRDark.css');
        kwiki.getCSS(loadpath+'styles/shCore.css');
        kwiki.getCSS(loadpath+'styles/shCoreMidnight.css');
        $.getScript(loadpath+'scripts/shCore.js', function() {
            $.getScript(loadpath+'scripts/shAutoloader.js', function(){
                SyntaxHighlighter.config.strings.expandSource = '+ 展开源码';
                SyntaxHighlighter.config.strings.viewSource = '新窗口查看源码';
                SyntaxHighlighter.config.strings.copyToClipboard = '复制到剪贴板';
                SyntaxHighlighter.config.strings.copyToClipboardConfirmation = '已经复制源码到剪切板';
                SyntaxHighlighter.config.strings.print = '打印';
                SyntaxHighlighter.config.strings.help = '';
                SyntaxHighlighter.config.strings.alert = '语法高亮器:\n';
                SyntaxHighlighter.config.strings.noBrush = '找不到下列语言的渲染器: ';
                SyntaxHighlighter.defaults['toolbar'] = false;
                //SyntaxHighlighter.defaults['collapse'] = true;
                SyntaxHighlighter.autoloader.apply(null, path(
                    'applescript            @shBrushAppleScript.js',
                    'actionscript3 as3      @shBrushAS3.js',
                    'bash shell             @shBrushBash.js',
                    'coldfusion cf          @shBrushColdFusion.js',
                    'cpp c                  @shBrushCpp.js',
                    'c# c-sharp csharp      @shBrushCSharp.js',
                    'css                    @shBrushCss.js',
                    'delphi pascal          @shBrushDelphi.js',
                    'diff patch pas         @shBrushDiff.js',
                    'erl erlang             @shBrushErlang.js',
                    'groovy                 @shBrushGroovy.js',
                    'java                   @shBrushJava.js',
                    'jfx javafx             @shBrushJavaFX.js',
                    'js jscript javascript  @shBrushJScript.js',
                    'perl pl                @shBrushPerl.js',
                    'php                    @shBrushPhp.js',
                    'text plain             @shBrushPlain.js',
                    'py python              @shBrushPython.js',
                    'ruby rails ror rb      @shBrushRuby.js',
                    'sass scss              @shBrushSass.js',
                    'scala                  @shBrushScala.js',
                    'sql                    @shBrushSql.js',
                    'vb vbnet               @shBrushVb.js',
                    'xml xhtml xslt html    @shBrushXml.js'
                ));
                SyntaxHighlighter.all();
            });
        });
    };
    syntaxHighlight();

    //Google自定义搜索
    /*
    //if(window.location.hostname=='' || window.location.hostname.indexOf('gdu.me') != -1)
    $.getScript('http://www.google.com/jsapi', function() {
        google.load('search', '1', {language: 'zh-CN', 'callback': cseloaded });
    });
    function cseloaded() {
        var customSearchControl = new google.search.CustomSearchControl('002820686095557729470:clbefwouje4');
        //customSearchControl.setResultSetSize(8);
        customSearchControl.setResultSetSize(google.search.Search.SMALL_RESULTSET);
        //customSearchControl.setLinkTarget(google.search.Search.LINK_TARGET_SELF);
        customSearchControl.setNoResultsString('哎哟喂，找不到这个东东呢……');

        var options = new google.search.DrawOptions();
        options.setAutoComplete(true);
        customSearchControl.draw('cse');

        var input = document.querySelector('input.gsc-input');
        input.style.cssText = '';
        input.className = 'gsc-input cesbg';
        input.onfocus = function() {
            if (input.className.indexOf('cesbg') >= 0) input.className = 'gsc-input';
        };
        input.onblur = function() {
            if (input.value == '') input.className = 'gsc-input cesbg';
        };
    };
    */

    //评论:duoshuo,disqus
    //if (!$.browser.msie && window.location.hostname!='') kwiki.loadCmt('duoshuo');
    if (window.location.hostname!='') kwiki.loadCmt('duoshuo');
});

//Google 统计
/*
if (window.location.hostname!='') {
    (function(i,s,o,g,r,a,m){i['GoogleAnalyticsObject']=r;i[r]=i[r]||function(){
    (i[r].q=i[r].q||[]).push(arguments)},i[r].l=1*new Date();a=s.createElement(o),
    m=s.getElementsByTagName(o)[0];a.async=1;a.src=g;m.parentNode.insertBefore(a,m)
    })(window,document,'script','//www.google-analytics.com/analytics.js','ga');
    ga('create', 'UA-46664569-1', 'gdu.me');
    ga('send', 'pageview');
}
*/

