// 需要修改
var $global_project = "uploader";

(function($) {

    // --------------------------------------
    // common
    // --------------------------------------

    $.extend({
        namespace2fn: function(name, fun) {
            if (name) {
                $.fn[name] = fun ? fun : function() {
                    arguments.callee.$ = this;
                    return arguments.callee;
                };
            }
            return this;
        },
        namespace2win: function() {
            var a = arguments,
                o = null,
                i, j, d;
            for (i = 0; i < a.length; i = i + 1) {
                d = a[i].split(".");
                o = window;
                for (j = (d[0] == "window") ? 1 : 0; j < d.length; j = j + 1) {
                    o[d[j]] = o[d[j]] || {};
                    o = o[d[j]];
                }
            }
            return o;
        },
        formatDate: function(date, format) {

            var o = {
                "M+": date.getMonth() + 1, // month
                "d+": date.getDate(), // day
                "h+": date.getHours(), // hour
                "m+": date.getMinutes(), // minute
                "s+": date.getSeconds(), // second
                "q+": Math.floor((date.getMonth() + 3) / 3), // quarter
                "S": date.getMilliseconds() // millisecond
            }
            if (/(y+)/.test(format)) format = format.replace(RegExp.$1, (date.getFullYear() + "").substr(4 - RegExp.$1.length));
            for (var k in o)
                if (new RegExp("(" + k + ")").test(format))
                    format = format.replace(RegExp.$1,
                        RegExp.$1.length == 1 ? o[k] :
                        ("00" + o[k]).substr(("" + o[k]).length));
            return format;
        },
        getUrlVariable: function(variable) {
            var query = window.location.search.substring(1);
            var vars = query.split("&");
            for (var i = 0; i < vars.length; i++) {
                var pair = vars[i].split("=");
                if (pair[0] == variable) { return pair[1]; }
            }
            return false;
        }
    });

    $.fn.serializeObject = function(param) {
        var obj = param || {};
        $(this).each(function() {
            var a = $(this).serializeArray();
            a.forEach(function(i) {
                if (i.value) {
                    var v = obj[i.name];
                    if (v) {
                        if (v instanceof Array) {
                            v.push(i.value);
                        } else {
                            var arr = [];
                            arr.push(v, i.value);
                            obj[i.name] = arr;
                        }
                    } else {
                        obj[i.name] = i.value;
                    }
                }
            });
        });

        return obj;
    };

    // --------------------------------------
    // constant
    // --------------------------------------

    _RESPONSE_STATUS = {
        NO_LOGIN: -1,
        NO_PERMISSION: -2,
        SUCCESS: 1,
        FAIL: 2,
        FAIL_VALID: 3,
        ERROR: 0
    };

    $.namespace2win('tonto.constant');

    // --------------------------------------
    // messager
    // --------------------------------------

    /*
     * 基于layer组件提供弹框消息，参考 http://www.layui.com/doc/modules/layer.html
     * 
     */

    $.extend({
        infoMessage: function(message, top) {
            layer.msg(message, { icon: 6, offset: top ? top : undefined });
        },
        failMessage: function(message, top) {
            layer.msg(message, { icon: 2, offset: top ? top : undefined });
        },
        errorMessage: function(message, top) {
            layer.msg(message, { icon: 5, offset: top ? top : undefined });
        },
        successMessage: function(message, top) {
            layer.msg(message, { icon: 1, offset: top ? top : undefined });
        },
        doAlert: function(msg, icon, fun, top) {
            if (typeof fun === 'number' || typeof fun === 'string') {
                top = fun;
            }
            layer.alert(msg, { icon: icon, offset: top ? top : undefined }, function(index) {
                layer.close(index);
                if (typeof fun === 'function') fun();
            });
        },
        successAlert: function(msg, fun, top) {
            $.doAlert(msg, 1, fun, top);
        },
        warnAlert: function(msg, fun, top) {
            $.doAlert(msg, 3, fun, top);
        },
        failAlert: function(msg, fun, top) {
            $.doAlert(msg, 2, fun, top);
        },
        errorAlert: function(msg, fun, top) {
            $.doAlert(msg, 5, fun, top);
        },
        infoAlert: function(msg, fun, top) {
            $.doAlert(msg, 6, fun, top);
        },
        isLayer: function() {
            if (parent && parent.layer && parent.layer.getFrameIndex(window.name)) {
                return true;
            } else {
                return false;
            }
        },
        openPageLayer: function(content, options) {
            options = options || {};

            if (typeof options == "string") {
                options = {
                    title: options
                }
            } else if (typeof options == "function") {
                options = {
                    success: options
                };
            }

            options = $.extend(options, {
                type: 1,
                title: options.title || '',
                maxmin: true, //开启最大化最小化按钮
                area: $.getOpenLayerSize(options.width, options.height),
                content: content,
                success: options.success
            });

            return layer.open(options);
        },
        openUrlLayerOrLocate: function(url, options) {
            if (options && options.data) {
                url = $.wrapGetUrl(url, options.data);
            }

            if ($.isLayer()) {
                window.location = url;
            }

            options = options || {};

            if (typeof options == "string") {
                options = {
                    title: options
                }
            } else if (typeof options == "function") {
                options = {
                    success: options
                };
            }

            options = $.extend(options, {
                type: 2,
                title: options.title || '',
                maxmin: true, //开启最大化最小化按钮
                area: $.getOpenLayerSize(options.width, options.height),
                content: url,
                success: options.success
            })

            return layer.open(options);
        },
        getOpenLayerSize: function(w, h) {
            w = w || 0.8;
            h = h || 0.9;

            var ww = $(window).width();
            var wh = $(window).height();

            if (w > ww) {
                w = ww * 0.8;
            } else if (w <= 1) {
                w = ww * w;
            }

            if (h > wh) {
                h = wh * 0.9;
            } else if (h <= 1) {
                h = wh * h;
            }

            return [w + "px", h + "px"];
        }
    });


    // --------------------------------------
    // ajax
    // --------------------------------------

    $.extend({
        validErrorHandler: function(response) {
            // $.errorMessage(data.message || "数据验证异常");
            var errorHtml, error = response.result;
            if (!response.message && $.isArray(error)) {
                var errorHtml = "<ul>数据验证失败："
                error.forEach(function(item) {
                    var el = item[1];
                    var errorMsg = item[2];

                    // 存在可能对不上input输入框，加上存在前端验证保证大部分情况正确，所以这里才有用户体验稍差的方式
                    // form.find("#" + el + ",[name='" + el + "']").each(function() {
                    //     layer.tips(errorMsg, $(this), { time: 2000, tips: [3, 'red'] });
                    // });

                    errorHtml += "<li>" + errorMsg + "</li>";
                });
                errorHtml += "</ul>"
            } else {
                errorHtml = response.message || error || "数据验证异常";
            }

            $.errorAlert(errorHtml);
        },
        ajaxUnLoginHandler: function(callback) {
            // ajax请求返回未登录状态处理
            // 暂时跳转主页面到登录页面，有时间可以做弹出登录窗口登录，成功后继续执行ajax请求处理
            $.failAlert("请先登录", function() {
                top.location.href = $global_project + "/login";
            })
        },
        ajaxResponseCheck: function(response) {
            if (typeof response === 'string') {
                response = JSON.parse(response)
            }
            var resStatus = response.status,
                status = _RESPONSE_STATUS;

            if (status.NO_LOGIN === resStatus) {
                $.ajaxUnLoginHandler(callback);
            } else if (status.NO_PERMISSION === resStatus) {
                $.errorMessage(response.message || "您没有权限访问该页面或执行该操作");
            } else if (status.ERROR === resStatus) {
                $.errorMessage(response.message || "访问页面或执行操作错误");
            } else if (status.FAIL === resStatus) {
                $.errorMessage(response.message || "操作失败");
            } else if (status.FAIL_VALID === resStatus) {
                $.validErrorHandler(response);
            } else {
                return true;
            }
            return false;
        },
        ajaxResponseHandler: function(response, callback) {
            if ($.ajaxResponseCheck(response) === true) {
                typeof callback === 'function' && callback(response.result);
            }
        },
        wrapAjaxSuccessCallback: function(callback, submitBtn) {

            if (callback && typeof callback != 'function' && !submitBtn) {
                submitBtn = callback;
            }

            if (submitBtn) {
                $(submitBtn).each(function() {
                    var that = $(this);
                    that.data("loading", true);
                    var text = that.text();
                    that.data("orginText", text);
                    that.text(text + '中...').prop('disabled', true).addClass('disabled');
                });
            }

            // 包装Ajax成功回调方法，过滤返回内容
            return function(response) {
                if (submitBtn) {
                    $(submitBtn).each(function() {
                        var that = $(this);
                        var text = that.text();
                        that.removeClass('disabled').prop('disabled', false).text(that.data("orginText"));
                    });
                }

                if (typeof response === 'string') {
                    response = JSON.parse(response)
                }
                var resStatus = response.status,
                    status = _RESPONSE_STATUS;

                if (status.NO_LOGIN === resStatus) {
                    $.ajaxUnLoginHandler(callback);
                } else if (status.NO_PERMISSION === resStatus) {
                    $.errorMessage(response.message || "您没有权限访问该页面或执行该操作");
                } else if (status.ERROR === resStatus) {
                    $.errorMessage(response.message || "访问页面或执行操作错误");
                } else if (status.FAIL === resStatus) {
                    $.errorMessage(response.message || "操作失败");
                } else if (status.FAIL_VALID === resStatus) {
                    $.validErrorHandler(response);
                } else {
                    if (callback && typeof callback === 'function') {
                        callback(response.result);
                    }
                }
            }
        },
        postJsonAjax: function(url, data, callback, submitBtn) {

            if (callback && typeof callback != 'function' && !submitBtn) {
                submitBtn = callback;
            }

            // 发送json格式ajax请求
            $.sendAjax({
                type: "POST",
                url: url,
                dataType: "json",
                data: JSON.stringify(data),
                contentType: "application/json",
                success: function(result) {
                    if (callback && typeof callback === 'function')
                        callback(result);
                },
                submitBtn: submitBtn
            });
        },
        sendAjax: function(options) {
            // 发送ajax请求 对应$.ajax()
            var callback = options.success;
            options.success = $.wrapAjaxSuccessCallback(callback, options.submitBtn);
            if (!options.complete && options.submitBtn) {
                options.complete = function() {
                    $(options.submitBtn).each(function() {
                        var that = $(this);
                        var text = that.text();
                        that.removeClass('disabled').prop('disabled', false).text(that.data("orginText"));
                    });
                };
            }
            if (!options.error) {
                options.error = function(xhr, e) {
                    $.errorMessage("系统异常:" + xhr.status);
                }
            }
            $.ajax(options);
        },
        getAjax: function(url, callback, submitBtn) {
            // 对应$.get()
            $.get(url, $.wrapAjaxSuccessCallback(callback, submitBtn));
        },
        postAjax: function(url, data, callback, submitBtn) {
            // 对应$.post()
            if (typeof data === 'function') {
                callback = data;
                data = null;
            }
            $.post(url, data, $.wrapAjaxSuccessCallback(callback, submitBtn));
        },
        postFormAjax: function(url, args) {
            // 提交表单形式ajax
            var form = $("<form method='post' action='" + url + "'></form>");
            $.each(args, function(key, value) {
                if (!$.isArray(value)) {
                    value = [value];
                }

                value.forEach(function(v) {
                    var input = $("<input type='hidden'>");
                    input.attr({ "name": key });
                    input.val(v);
                    form.append(input);
                });
            });
            form.appendTo(document.body);
            form.submit();
            document.body.removeChild(form[0]);
        },
        wrapGetUrl: function(url, data) {
            if (data) {
                var i = url.indexOf("?");
                if (i > 0) {
                    if (i < (url.length - 1)) {
                        url += "&";
                    }
                } else {
                    url += "?";
                }

                for (var o in data) {
                    var d = data[o];
                    if (d) {
                        if (!$.isArray(d)) {
                            d = [d];
                        }
                        d.forEach(function(x) {
                            url += o + "=" + x + "&";
                        });
                    }
                }
            }
            return url;
        },
        locationPost: function(url, args, target) {
            var form = $("<form method='post' action='" + url + "' target='" + (target || "_self") + "'></form>");
            $.each(args, function(key, value) {
                var input = $("<input type='hidden'>");
                input.attr({ "name": key });
                input.val(value);
                form.append(input);
            });
            form.appendTo(document.body);
            form.submit();
            document.body.removeChild(form[0]);
        }
    });

    // --------------------------------------
    // 事件分发器
    // --------------------------------------

    $.namespace2win('tonto.event');

    var event_Dispatcher = function() {

    }

    event_Dispatcher.prototype.addEventListener = function(event, callback) {
        var map = this.listenerMap || (this.listenerMap = {});
        var listeners = map[event] || (map[event] = new Array());
        listeners.push(callback);
    }

    event_Dispatcher.prototype.distribute = function(event, data) {
        var map = this.listenerMap || (this.listenerMap = {});
        var listeners = map[event];
        if (listeners) {
            for (var i = 0; i < listeners.length; i += 1) {
                listeners[i].call(this, data);
            }
        }
    }

    tonto.event.Dispatcher = event_Dispatcher;

    // ------------------------------------------
    //
    // 页面处理
    //
    // -----------------------------------------

    $.fn.showInfoDescription = function(items, isHorizontal) {
        _showInfoDescription(items, $(this), isHorizontal);
    }


    // -----------------------------------------
    //
    // cache
    //
    // -----------------------------------------

    window.mycache = {};

    $.extend({
        putCache: function(key, value) {
            window.mycache[key] = value;
        },
        getCache: function(key) {
            return window.mycache[key];
        }
    });


    // -----------------------------------------
    //
    // 其他
    //
    // -----------------------------------------


    $.extend({
        beautifyInput: function(input, icon, isBefore) {
            var a = $(input);
            a.wrap('<div class="input-group"></div>');
            var b = '<span class="input-group-addon"><i class="' + icon + '"></i></span>';
            if (isBefore) {
                a.before(b);
            } else {
                a.after(b);
            }
            return a;
        },
        formatSensitive: function(str, a, b, c) {
            if (typeof str !== 'string') {
                return "";
            }
            var l = str.length;
            if (a === undefined || typeof a !== 'number') {
                a = Math.floor(l / 3.5);
            }
            if (b === undefined || typeof b !== 'number') {
                b = Math.floor(l / 3.5);
            }
            return str.substring(0, a) + (c ? c : "*****") + str.substring(l - b);
        }
    });

    // ------------------------------------------
    //
    // 常用业务控件和方法
    //
    // -----------------------------------------

    $.extend($.fn, {
        resetSearch: function() {
            $(this)[0].reset();
        }
    });

    _initValidator();
    _initTable();

    $.extend({
        initComponment: function(container) {
            _initEnumConstant(container);
            _initForm(container);
            _initAttachment(container);
            _initCommon(container);
        }
    })

    if (window.needInitComponet !== false) {
        $.initComponment();
    }



})(jQuery);


function _initCommon(container) {

    container = $(container);
    if (container.length == 0) {
        container = $("body");
    }

    // 关键词搜索框添加绑定回车函数
    container.find('.tonto-btn-search').each(function() {
        var btn = $(this);
        $("body").bind('keypress', function(event) {
            if (event.keyCode == "13") {
                btn.click();
            }
        });
    });

    container.find('.tonto-select').each(function() {
        var that = $(this);
        var selected = that.attr("selectedvalue");
        if (selected) {
            that.val(selected);
        }
    });

    container.find('.tonto-datepicker-date').each(function() {
        $.beautifyInput(this, "fa fa-calendar", false);
        laydate.render({
            elem: this,
            type: "date",
            calendar: true, //开启公历节日
            theme: 'molv', //墨绿主题
            showBottom: true, //是否出现底部栏
            trigger: 'click' //绑定多个
        });
    });

    container.find('.tonto-datepicker-year').each(function() {
        $.beautifyInput(this, "fa fa-calendar", false);
        laydate.render({
            elem: this,
            type: "year",
            calendar: true, //开启公历节日
            theme: 'molv', //墨绿主题
            showBottom: true, //是否出现底部栏
            trigger: 'click' //绑定多个
        });
    });

    container.find('.tonto-datepicker-datetime').each(function() {
        $.beautifyInput(this, "fa fa-calendar", false);
        laydate.render({
            elem: this,
            type: "datetime",
            calendar: true, //开启公历节日
            theme: 'molv', //墨绿主题
            showBottom: true, //是否出现底部栏
            trigger: 'click' //绑定多个
        });
    });

    container.find('.tonto-datepicker-time').each(function() {
        $.beautifyInput(this, "fa fa-clock-o", false);
        laydate.render({
            elem: this,
            type: "time",
            calendar: true, //开启公历节日
            theme: 'molv', //墨绿主题
            showBottom: true, //是否出现底部栏
            trigger: 'click' //绑定多个
        });
    });

    container.find('input').iCheck({
        checkboxClass: 'icheckbox_square-blue', // 注意square和blue的对应关系
        radioClass: 'iradio_square-blue'
        //increaseArea: '10%' // optional
    });

    // 必须在icheck后面，否则需要更改源代码适用icheck
    container.find('.tonto-multiple-select').each(function() {
        $(this).select2({
            placeholder: $(this).attr("placeholder") || "请选择", //未选择时显示文本
            maximumSelectionSize: $(this).attr("max-selection-size") || null, //显示最大选项数目
            multiple: true,
            width: '100%',
            allowClear: true
        });
    });

    // 搜索按钮回车
    container.find('.tonto-btn-search').each(function() {
        var a = $(this);
        $(document).keyup(function(event) {
            if (event.keyCode == 13) {
                a.click();
            }
        });
    })

    $.extend({
        createTreeSelectComponment: function(input, type) {
            var $input = $(input);
            var $wrap = $('<div class="input-group"/>');
            var name = $input.attr("name") || $input.attr("id");
            $input.attr("name", "_" + name);
            var $hideinput = $('<input type="text" style="display:none" name="' + name + '" id="' + name + '"  />');
            var $removeBtn = $('<span class="input-group-addon" style="cursor:pointer"><i class="glyphicon glyphicon-remove"> </i></span>');
            var initValue = $input.attr("selectedvalue") || $input.val();

            $input.attr("readonly", true);
            $input.css("background", "#fff");

            $input.wrap($wrap);
            $input.after($removeBtn);
            $input.after($hideinput);

            var com = {
                input: $input,
                removeBtn: $removeBtn,
                name: name,
                valueInput: $hideinput,
                current: null,
                initValue: initValue,
                type: type,
                treedata: null,
                changedCallback: null,
                setCurrent: function(val) {
                    var that = this;

                    if (!that.current && !val) {
                        return;
                    }
                    if (that.current && val && that.current.value == val.value) {
                        return;
                    }

                    that.current = val;
                    that.input.val(val ? val.name : "");
                    that.valueInput.val(val ? val.value : "");

                    if (that.changedCallback) {
                        that.changedCallback(val);
                    }
                },
                getCurrent: function() {
                    var that = this;
                    if (!that.valueInput.val()) {
                        that.current = null;
                        return null;
                    }
                    return that.current;
                },
                setEnabled: function(enabled) {
                    if (enabled) {
                        this.input.attr('disabled', false);
                        this.valueInput.attr('disabled', false);
                        this.input.css("background", "#fff");
                    } else {
                        this.input.attr('disabled', true);
                        this.valueInput.attr('disabled', true);
                        this.input.css("background", "#eee");
                    }
                },
                setData: function(datalist) {
                    var that = this;
                    that.datalist = datalist;
                    var initValue = that.initValue;
                    var current;

                    var g = function(ns, all) {
                        if (!all) {
                            all = ns;
                            ns = $.grep(all, function(a, b) {
                                return a.parentValue === "-";
                            });
                        }
                        var nodes = [];
                        ns.forEach(function(n) {
                            var node = {
                                text: n.name,
                                data: n
                            };

                            if (n.value === initValue) {
                                current = n;
                            }

                            var parentValue = n.value;
                            var children = $.grep(all, function(a, b) {
                                return a.parentValue == parentValue;
                            });

                            if (children && children.length > 0) {
                                node.nodes = g(children, all);
                            }

                            nodes.push(node);
                        });
                        return nodes;
                    }

                    that.treedata = g(datalist);
                    that.setCurrent(current);

                    that.removeBtn.on("click", function() {
                        that.setCurrent(null);
                    });

                    that.input.click(function() {
                        layer.open({
                            type: 1,
                            title: "",
                            content: "<div class='tonto-tree-div'></div>",
                            area: ['350px', '460px'],
                            success: function(layero, index) {
                                $tree = $(layero).find('.tonto-tree-div');

                                $tree.treeview({
                                    data: that.treedata,
                                    levels: 1
                                });

                                $tree.on('nodeSelected', function(event, node) {
                                    var data = node.data;

                                    if (data.description === '不可选') {
                                        $.infoMessage("您不能选择该选项");
                                        return;
                                    }

                                    that.setCurrent(data);
                                    layer.close(index);
                                });
                            }
                        });
                    });
                }
            }

            $input.data("Tree_Select", com);
            $hideinput.data("Tree_Select", com);

            return com;
        }
    });
}

function _initValidator() {
    // --------------------------------------
    // Validate
    // --------------------------------------

    // this.optional(element) 指定了表单不为空才判断

    // 自然数
    $.validator.addMethod("naturalNumber", function(value, element) { return this.optional(element) || (/^[1-9]\d{0,9}$/.test(value)); }, "请输入大于0小于9999999999的整数");
    // 身份证
    $.validator.addMethod("identity", function(value, element) {
        var id = /(^\d{15}$)|(^\d{18}$)|(^\d{17}(\d|X|x)$)/;

        if (!id.test(value))
            return this.optional(element) || false;

        var y = value.substring(6, 10) * 1;
        var m = value.substring(10, 12) * 1 - 1;
        var d = value.substring(12, 14) * 1;

        var date = new Date(y, m, d);

        return this.optional(element) || (date.getFullYear() == y && date.getMonth() == m && date.getDate() == d);
    }, "身份证格式错误");
    // 邮编
    $.validator.addMethod("zip", function(value, element) { return this.optional(element) || (/^[0-9]\d{5}$/.test(value)); }, "邮编格式错误");
    // 账号
    $.validator.addMethod("account", function(value, element) { return this.optional(element) || (/^\w{5,30}$/.test(value)); }, "账号格式错误");
    // 手机
    $.validator.addMethod("cellphone", function(value, element) { return this.optional(element) || (/^[1][3,4,5,7,8][0-9]{9}$/.test(value)); }, "手机号码格式错误");
    // 电话（包括手机和座机）
    $.validator.addMethod("phone", function(value, element) { return this.optional(element) || (/((^\d{3,4}-?)?\d{7,8}(-(\d{3,}))?$)|(^[1][3,4,5,7,8][0-9]{9}$)/.test(value)); }, "电话号码格式错误");

    // 日期
    $.validator.addMethod("date", function(value, element) {
        var r = value.match(/^(\d{1,4})(-|\/)(\d{1,2})\2(\d{1,2})$/);
        if (r == null)
            return this.optional(element);

        var d = new Date(r[1], r[3] - 1, r[4]);
        return this.optional(element) || (d.getFullYear() == r[1] && (d.getMonth() + 1) == r[3] && d.getDate() == r[4]);
    }, "日期格式不正确");

    // 大于
    $.validator.addMethod("largeThan", function(value, element, $name) {
        if ($name) {
            var minVal = $($name).val();
            if (minVal) {
                if (("string" === typeof(minVal) && /\d+\.?\d*/.test(minVal)) || "number" === typeof(minVal))
                    return this.optional(element) || value >= minVal * 1;
            }
        }
        return true;
    }, "输入值不能小于最小值");

    $.validator.addMethod("maxEngLength", function(value, element, maxlength) { return this.optional(element) || (value.replace(/[^\x00-\xff]/g, 'xx').length <= maxlength); }, "输入长度不能超过{0}");
    $.validator.addMethod("minEngLength", function(value, element, minlength) { return this.optional(element) || (value.replace(/[^\x00-\xff]/g, 'xx').length >= minlength); }, "输入长度不能少于{0}");

    $.extend($.fn, {
        createElementValidater: function(config, requiredStyle) {
            // 创建元素验证器
            for (var i = 0; this.length > i; i++) {
                var target = $(this[i]);

                if (target.hasClass("no-validate")) {
                    continue;
                }

                var name = target.attr("name");
                var rules = config && config.rules && config.rules[name] || {};
                var messages = config && config.messages && config.messages[name] || {};

                var title = $("label[for='" + name + "']").text();
                title = $.trim(title);
                if (title && title.endsWith(":")) {
                    title = title.substring(0, title.length - 1);
                }

                var type = target.attr("data-type");
                if (type) {
                    if (type.indexOf(" ") != -1) {
                        var ts = type.split(" ");
                        for (var j = 0; j < ts.length; j++) {
                            rules[ts[j]] = true;
                        }
                    } else {
                        rules[type] = true;
                    }
                }

                if (target.hasClass("required") || target.attr("required") == "required") {
                    rules.required = true;

                    if (requiredStyle) {
                        target.addRequiredStyle();
                    }

                    if (!messages.required) {
                        var placeholder = target.attr("placeholder");
                        if (placeholder) {
                            messages.required = placeholder;
                        } else {
                            var domType = target[0].type;
                            if (domType == "text" || domType == "password") {
                                messages.required = "请输入" + title;
                            } else {
                                messages.required = "请选择" + title;
                            }
                        }
                    }
                }

                var area = target.attr("data-area");
                if (area) {
                    var numbers = area.split(",");
                    if (numbers.length > 0) {
                        if (numbers[0])
                            rules.min = numbers[0] * 1;
                        if (numbers.length > 1) {
                            if (numbers[1])
                                rules.max = numbers[1] * 1;
                        }
                    }
                }

                var length = target.attr("data-length");
                if (length) {
                    var lengths = length.split(",");
                    if (lengths) {
                        if (lengths.length > 0) {
                            if (lengths[0])
                                rules.minlength = lengths[0] * 1;
                            if (lengths.length > 1) {
                                if (lengths[1])
                                    rules.maxlength = lengths[1] * 1;
                            }
                        }
                    }
                }

                var length = target.attr("data-eng-length");
                if (length) {
                    var lengths = length.split(",");
                    if (lengths) {
                        if (lengths.length > 0) {
                            if (lengths[0])
                                rules.minEngLength = lengths[0] * 1;
                            if (lengths.length > 1) {
                                if (lengths[1])
                                    rules.maxEngLength = lengths[1] * 1;
                            }
                        }
                    }
                }

                var equalTo = target.attr("equalTo");
                if (equalTo) {
                    rules["equalTo"] = equalTo;
                }

                var largeThan = target.attr("large-than");
                if (largeThan) {
                    rules["largeThan"] = largeThan;
                    if (!messages.largeThan) {

                        var thanTarget = $(largeThan);
                        var thanName = thanTarget.attr("name");
                        var thanTitle = $("label[for='" + thanName + "']").text();
                        thanTitle = $.trim(thanTitle);
                        if (thanTitle && thanTitle.endsWith(":")) {
                            thanTitle = thanTitle.substring(0, thanTitle.length - 1);
                        }

                        if (thanTitle) {
                            messages.largeThan = "输入值必须大于" + thanTitle + "的值";
                        }
                    }
                }

                rules.messages = messages;
                target.rules("add", rules);
            }
        },
        createFormValidater: function(config) {
            // 创建表单验证器
            var validater = this.validate(config);
            this.find("input[type='text']:enabled,input[type='password']:enabled,input[type='hidden']:enabled,select:enabled,textarea:enabled").createElementValidater(config);
            this.data("validater", validater);
            return validater;
        },
        validateElement: function(element) {
            // 验证某个元素
            var validater = $(this).data("validater");
            return validater ? validater.element(element) : true;
        },
        addRequiredStyle: function() {
            // 添加必填样式
            // var target = $(this);
            // var inputGroupParent = target.parent(".input-group");
            // if (inputGroupParent.length > 0) {
            //     inputGroupParent.children(":last-child").css("border-right", "2px solid red");
            // } else {
            //     target.css("border-right", "2px solid red");
            // }
        },
        removeRequiredStyle: function() {
            // 移除必填样式
            var target = $(this);
            var inputGroupParent = target.parent(".input-group");
            if (inputGroupParent.length > 0) {
                inputGroupParent.children(":last-child").css("border-right", "");
            } else {
                target.css("border-right", "");
            }
        }
    });
}

function _initTable() {
    /*
     * options 参数配置基于bootstrp table，参考
     * http://bootstrap-table.wenzhixin.net.cn/zh-cn/documentation/ 修改参数： url:
     * 可以为方法，返回具体url字符串
     * 
     * 其中对table tree做了处理，可以获取指定form中的request param
     */
    var _tonto_table = function(el, options) {

        var defaultOptions = $.fn.bootstrapTable.defaults;

        if (typeof options === 'string')
            options = {
                url: options
            };

        if (!options.ajax && options.url !== false) {
            options.ajax = function(request) {
                if (typeof url === 'function') {
                    request.url = request.url();
                }
                if (options.joinArrayValue) {
                    var d = request.data;
                    if (d) {
                        for (var o in d) {
                            var v = d[o];
                            if (v instanceof Array) {
                                d[o] = v.join(",");
                            }
                        }
                    }
                }
                $.sendAjax(request);
            }
        }

        if (!options.classes) {
            if (window.screen.height <= 900 || window.screen.width <= 1600) {
                options.classes = "table table-hover table-border table-striped table-condensed";
            } else {
                options.classes = "table table-hover table-border table-striped";
            }
        }

        if (options.columns) {
            options.columns.forEach(function(item) {

                // 对列统一处理

                if (!$.isArray(item)) {
                    item = [item];
                }

                item.forEach(function(col) {
                    // formatter 定义数据类型转换，例如time，date等，在这里定义
                    if (col.formatter && typeof col.formatter === 'string') {
                        col.formatType = col.formatter;
                        if (col.formatter == 'date') {
                            col.formatter = function(value, row, index) {
                                if (value) {
                                    if (!isNaN(value)) {
                                        return $.formatDate(new Date(value), "yyyy-MM-dd");
                                    }
                                    return value;
                                }
                                return "";
                            }
                        } else if (col.formatter == 'datetime') {
                            col.formatter = function(value, row, index) {
                                if (value) {
                                    if (!isNaN(value)) {
                                        return $.formatDate(new Date(value), "yyyy-MM-dd hh:mm:ss");
                                    }
                                    return value;
                                }
                                return "";
                            }
                        } else if (col.formatter == 'boolean') {
                            col.formatter = function(value, row, index) {
                                return (value === true || value === "true") ? "是" : "否";
                            }
                        } else if (col.formatter == 'identification') {
                            col.formatter = function(value, row, index) {
                                return hideIdentification(value);
                            }
                        }
                    }

                    // 枚举情况
                    if (col.enumcode && !col.formatter) {
                        col.formatter = $.getEnumColumnFormatter(window._constant_cache, col.enumcode, col.multiple === true);
                    }

                    if (!col.align) {
                        col.align = "center";
                    }

                    if (!col.valign) {
                        col.valign = "middle";
                    }


                });
            });
        }

        var selfOptions = {
            sidePagination: 'server',
            dataField: 'data',
            totalField: 'total',
            treeParentField: 'parentId',
            pageList: [10, 20, 50, 100],
            pageSize: 10
        }



        options = $.extend(selfOptions, options);

        // 回显时，页码回显
        var _limit = $(options.pageLimitEL || "#pageLimit").val() * 1,
            _offset = $(options.pageOffsetEL || "#pageOffset").val() * 1,
            _page = (_limit && _offset) ? _offset / _limit + 1 : 1;

        if (_limit) {
            options.pageSize = _limit;
            options.pageNumber = _page;
        }

        if (!options.pageSize || options.pageSize * 1 <= 0) {
            options.pageSize = 10;
        } else if (options.pageSize * 1 > 100) {
            options.pageSize = 100;
        }

        if (options.searchbar) {
            var q = options.queryParams;

            options.queryParams = function(params) {
                if (q) {
                    params = q(params);
                }

                $(options.searchbar).serializeObject(params);

                return params;
            };
        }

        if (options.treeView) {

            // 对树状table支持，需要treetable.js

            var rh = options.responseHandler;
            options.responseHandler = function(res) {
                // 因为treetable插件中写死了使用parentId，这里需要对返回结果处理下(可以改写插件)
                if (rh)
                    res = rh(res);
                res = res || [];

                var isArray = $.isArray(res);

                var dataField = options.dataField || defaultOptions.dataField;
                var totalField = options.totalField || defaultOptions.totalField;

                var data = isArray ? res : res[dataField];

                if ($.isArray(data)) {
                    var idArr = [];
                    data.forEach(function(item) {
                        item.parentId = item[options.treeParentField];
                        // 如果支持搜索，则会有部分父节点没搜索出来（当然你可以只查询过滤叶节点），
                        // 在这里会把没有父节点的节点parentId = null，因而造成数据可能会不完整，使用时候注意
                        if (options.treeParentFilter && item.parentId) {
                            var treeId = options.treeId || defaultOptions.treeId;
                            var b = false;
                            for (var i = 0; i < data.length; i++) {
                                var a = data[i];
                                if (a[treeId] == item.parentId) {
                                    b = true;
                                    break;
                                }
                            }

                            if (!b) {
                                item.parentId = null;
                            }
                        }
                    });
                }

                if ($.isArray(res)) {
                    var x = {};
                    x[dataField] = res;
                    x[totalField] = res.length;
                    return x;
                } else {
                    return res;
                }
            };

            if (options.data) {
                options.responseHandler(options.data);
            }
        }

        if (!options.responseHandler) {
            // 用于判断对返回数据的简单处理，当结果是一个数组时对其封装为table能接收的格式
            options.responseHandler = function(res) {
                res = res || [];
                if ($.isArray(res)) {
                    var dataField = options.dataField || defaultOptions.dataField;
                    var totalField = options.totalField || defaultOptions.totalField;

                    var x = {};
                    x[dataField] = res;
                    x[totalField] = res.length;
                    return x;
                } else {
                    return res;
                }
            }
        }

        var $table = $(el);
        $table.bootstrapTable(options);
        return $table.data('bootstrap.table');
    };

    $.extend({
        /**
         * 创建boostrap table
         */
        createTable: function(el, options) {
            var tables = [];
            $(el).each(function(index) {
                tables.push(new _tonto_table($(this), options));
            });

            return tables.length == 1 ? tables[0] : tables;
        },
        /**
         * 获取常量formatter方法，用于bootstrap table column *
         */
        getEnumColumnFormatter: function(enumTypeMap, type, multiple) {
            if (enumTypeMap && type) {
                return function(value, row, index) {
                    if (!value && value !== 0) {
                        return "";
                    }

                    var arr = [],
                        data = enumTypeMap[type];

                    if (!data) {
                        return "";
                    }

                    if (!$.isArray(value)) {
                        if (!multiple) {
                            value = [value];
                        } else {
                            value = value.split(",");
                        }
                    }

                    value.forEach(function(v) {
                        for (var i = 0; i < data.length; i++) {
                            if (data[i].key == v) {
                                arr.push(data[i].value);
                            }
                        }
                    });

                    return arr.length > 0 ? arr.join("，") : "";
                };
            }
        },
        tableColumnFormatter: function(text, type, icon) {
            return function() { return '<a class="' + type + '" href="javascript:void(0);" ><i class="glyphicon glyphicon-' + (icon ? icon : 'cog') + '"></i>' + text + '</a>' };
        },
        addColumnFormatter: function(text) {
            return function() { return '<a class="add" href="javascript:void(0);" ><i class="glyphicon glyphicon-plus"></i>' + (text ? text : '新增') + '</a>' };
        },
        removeColumnFormatter: function(text) {
            return function() { return '<a class="remove" href="javascript:void(0);" ><i class="glyphicon glyphicon-remove"></i>' + (text ? text : '删除') + '</a>' };
        },
        editColumnFormatter: function(text) {
            return function() { return '<a class="edit" href="javascript:void(0);" ><i class="glyphicon glyphicon-edit"></i>' + (text ? text : '修改') + '</a>' };
        },
        viewColumnFormatter: function(text) {
            return function() { return '<a class="view" href="javascript:void(0);" ><i class="glyphicon glyphicon-eye-open"></i>' + (text ? text : '查看') + '</a>' };
        },
        confirmColumnFormatter: function(text) {
            return function() { return '<a class="confirm" href="javascript:void(0);" ><i class="glyphicon glyphicon-edit"></i>' + (text ? text : '确认') + '</a>' };
        },
        checkColumnFormatter: function(text) {
            return function() { return '<a class="check" href="javascript:void(0);" ><i class="glyphicon glyphicon-eye-open"></i>' + (text ? text : '确认') + '</a>' };
        }
    });

    $.fn.createTable = function() {
        var tables = [];
        this.each(function() {
            tables.push(new _tonto_table($(this), options));
        });
        return tables.length == 1 ? tables[0] : tables;
    };

    // 页码本地化

    $.fn.bootstrapTable.locales['zh-CN'] = {
        formatLoadingMessage: function() {
            return '正在努力地加载数据中，请稍候……';
        },
        formatRecordsPerPage: function(pageNumber) {
            return pageNumber;
        },
        formatShowingRows: function(pageFrom, pageTo, totalRows) {
            return '显示' + pageFrom + ' - ' + pageTo + '条 ，共 ' + totalRows + ' 条';
        },
        formatSearch: function() {
            return '搜索';
        },
        formatNoMatches: function() {
            return '没有找到匹配的记录';
        },
        formatPaginationSwitch: function() {
            return '隐藏/显示分页';
        },
        formatRefresh: function() {
            return '刷新';
        },
        formatToggle: function() {
            return '切换';
        },
        formatColumns: function() {
            return '列';
        },
        formatExport: function() {
            return '导出数据';
        },
        formatClearFilters: function() {
            return '清空过滤';
        }
    };

    $.extend($.fn.bootstrapTable.defaults, $.fn.bootstrapTable.locales['zh-CN']);

    // 修改排序部分代码，使sortName起效
    if ($.fn.bootstrapTable) {
        var BootstrapTable = $.fn.bootstrapTable.Constructor;
        BootstrapTable.prototype.onSort = function(event) {
            var $this = event.type === "keypress" ? $(event.currentTarget) : $(event.currentTarget).parent(),
                $this_ = this.$header.find('th').eq($this.index()),
                sortName = this.header.sortNames[$this.index()];

            this.$header.add(this.$header_).find('span.order').remove();

            if (this.options.sortName === $this.data('field')) {
                this.options.sortOrder = this.options.sortOrder === 'asc' ? 'desc' : 'asc';
            } else {
                this.options.sortName = sortName || $this.data('field');
                this.options.sortOrder = $this.data('order') === 'asc' ? 'desc' : 'asc';
            }
            this.trigger('sort', this.options.sortName, this.options.sortOrder);

            $this.add($this_).data('order', this.options.sortOrder);

            // Assign the correct sortable arrow
            this.getCaret();

            if (this.options.sidePagination === 'server') {
                this.initServer(this.options.silentSort);
                return;
            }

            this.initSort();
            this.initBody();
        };

        BootstrapTable.prototype.getCaret = function() {
            var that = this;

            $.each(this.$header.find('th'), function(i, th) {
                var sortName = that.header.sortNames[i];
                $(th).find('.sortable').removeClass('desc asc').addClass((sortName || $(th).data('field')) === that.options.sortName ? that.options.sortOrder : 'both');
            });
        };

        BootstrapTable.prototype.export = function() {
            var columnHtml = "",
                that = this,
                exportColumns = [];

            $.each(that.columns, function(i, column) {
                if (column.radio || column.checkbox) {
                    return;
                }

                if (column.field == column.fieldIndex) {
                    return;
                }

                if (that.options.cardView && !column.cardVisible) {
                    return;
                }

                if (column.exportable === false) {
                    return;
                }

                exportColumns.push({
                    auto: true,
                    field: column.field,
                    name: column.title || column.field,
                    checked: column.visible,
                    column: column
                });
            });

            if (typeof that.options.exportColumn === 'function') {
                exportColumns = that.options.exportColumn(exportColumns);
            }

            $.each(exportColumns, function(i, column) {
                columnHtml += '<label class="control-label radio-label"><input type="checkbox" ' + (column.checked ? ' checked="checked"' : '') + ' name="dataColumn" value="' + column.field + '">&nbsp;&nbsp;' + column.name + '&nbsp;&nbsp;</label>'
            });

            var exportHtml = '<div style="padding:30px;padding-top:20px">' +
                '<form id="export_form" action="" method="post" class="form-horizontal" novalidate="novalidate">' +
                '    <div class="form-group">' +
                '        <label for="fileType" class="col-sm-3 control-label">文件类型：</label>' +
                '        <div class="col-sm-8">' +
                '            <select name="fileType" class="form-control">' +
                '                <option value="excel">Excel</option>' +
                '            </select>' +
                '        </div>' +
                '    </div>' +
                '    <div class="form-group">' +
                '        <label for="dataScope" class="col-sm-3 control-label">导出范围：</label>' +
                '        <div class="col-sm-8">' +
                '            <select name="dataScope" class="form-control">' +
                '                <option value="all">当前全部记录</option>' +
                '                <option value="page">当前页记录</option>' +
                '            </select>' +
                '        </div>' +
                '    </div>' +
                '    <div class="form-group">' +
                '        <label for="dataColumn" class="col-sm-3 control-label">导出列：</label>' +
                '        <div id="_dataColumnDiv" class="col-sm-9">' +
                columnHtml +
                '        </div>' +
                '    </div>' +
                '    <div class="form-group">' +
                '        <div class="col-sm-4 col-sm-offset-3">' +
                '            <button type="button" id="_exportSubmitBtn" class="btn btn-primary btn-block">导出</button>' +
                '        </div>' +
                '    </div>' +
                '</form></div>';

            $.openPageLayer(exportHtml, {
                title: "导出",
                width: 600,
                height: 420,
                success: function(layero, layeroIndex) {
                    $('#_dataColumnDiv').find("input").iCheck({
                        checkboxClass: 'icheckbox_square-blue', // 注意square和blue的对应关系
                        radioClass: 'iradio_square-blue'
                        //increaseArea: '10%' // optional
                    });

                    $("#_exportSubmitBtn").click(function() {
                        var param = {
                                fileType: $("#export_form").find("[name='fileType']").val(),
                                dataScope: $("#export_form").find("[name='dataScope']").val(),
                                columns: []
                            },
                            firstTd = that.$body.find("tr:eq(0)"),
                            totalWidth = 0,
                            totalCount = 0;

                        $("#export_form").find("input[name='dataColumn']:checked").each(function() {
                            var v = $(this).val(),
                                c;
                            for (var i = 0; i < exportColumns.length; i++) {
                                if (exportColumns[i].field == v) {
                                    c = exportColumns[i];
                                    break;
                                }
                            }

                            if (c) {
                                if (c.auto === true) {
                                    var f = c.column.formatType,
                                        q = {
                                            field: c.field,
                                            name: c.name,
                                            multiple: c.column.multiple === true ? true : false
                                        };

                                    if (f) {
                                        q.dateFormat = f == 'date' ? 'yyyy/MM/dd' : (f == 'datetime' ? 'yyyy/MM/dd HH:mm:ss' : null);
                                    }

                                    q.enumType = c.column.enumcode ? c.column.enumcode : null;

                                    if (!c.column.exportColumnWidth) {
                                        // 粗略计算width
                                        q.width = firstTd.find("td:eq('" + c.column.fieldIndex + "')").width();
                                        q.realWidth = false;
                                        totalWidth += q.width;
                                        totalCount++;
                                    } else {
                                        q.width = c.column.exportColumnWidth;
                                    }

                                    if (c.column.exportOption) {
                                        q = $.extend(q, c.column.exportOption);
                                    }

                                    param.columns.push(q);
                                } else {
                                    param.columns.push(c);
                                }
                            }
                        });

                        if (param.columns.length == 0) {
                            $.errorMessage("没有可导出的列");
                            return;
                        }

                        param.columns.forEach(function(c) {
                            if (c.realWidth === false) {
                                // c.width = Math.ceil(c.width / totalWidth * 1200 * totalCount / 120);
                                c.width = Math.ceil(c.width * totalCount * 24 / totalWidth);
                                c.width = Math.max(c.width, c.name.length * 2 + 2);
                                c.realWidth = true;
                            }

                            if (c.width > 255 * 256) {
                                c.width = 255 * 256;
                            }
                        });

                        // copy from bootstrap-table begin
                        var data = {},
                            index = $.inArray(that.options.sortName, that.header.fields),
                            params = {
                                searchText: that.searchText,
                                sortName: that.options.sortName,
                                sortOrder: that.options.sortOrder
                            },
                            request;

                        if (that.header.sortNames[index]) {
                            params.sortName = that.header.sortNames[index];
                        }

                        if (that.options.pagination && that.options.sidePagination === 'server') {
                            params.pageSize = that.options.pageSize === that.options.formatAllRows() ?
                                tthatis.options.totalRows : that.options.pageSize;
                            params.pageNumber = that.options.pageNumber;
                        }

                        if (that.options.queryParamsType === 'limit') {
                            params = {
                                search: params.searchText,
                                sort: params.sortName,
                                order: params.sortOrder
                            };

                            if (that.options.pagination && that.options.sidePagination === 'server') {
                                params.offset = that.options.pageSize === that.options.formatAllRows() ?
                                    0 : that.options.pageSize * (that.options.pageNumber - 1);
                                params.limit = that.options.pageSize === that.options.formatAllRows() ?
                                    that.options.totalRows : that.options.pageSize;
                                if (params.limit === 0) {
                                    delete params.limit;
                                }
                            }
                        }

                        if (!($.isEmptyObject(that.filterColumnsPartial))) {
                            params.filter = JSON.stringify(that.filterColumnsPartial, null);
                        }

                        var calculateObjectValue = function(self, name, args, defaultValue) {
                            var func = name;

                            if (typeof name === 'string') {
                                // support obj.func1.func2
                                var names = name.split('.');

                                if (names.length > 1) {
                                    func = window;
                                    $.each(names, function(i, f) {
                                        func = func[f];
                                    });
                                } else {
                                    func = window[name];
                                }
                            }
                            if (typeof func === 'object') {
                                return func;
                            }
                            if (typeof func === 'function') {
                                return func.apply(self, args || []);
                            }
                            if (!func && typeof name === 'string' && sprintf.apply(this, [name].concat(args))) {
                                return sprintf.apply(this, [name].concat(args));
                            }
                            return defaultValue;
                        };

                        data = calculateObjectValue(that.options, that.options.queryParams, [params], data);

                        if (data === false) {
                            return;
                        }
                        // copy from bootstrap-table end

                        param.query = params;

                        $.postJsonAjax(that.options.exportUrl, param, function(fileUrl) {
                            $.successAlert("导出数据成功", function() {
                                layer.close(layeroIndex);
                            });

                            window.open("/file" + fileUrl);
                        }, $("#_exportSubmitBtn"));
                    });
                }
            });

        };
    }
}


/**
 * 自动加载常量下拉框 <class = tonto-select-constant>
 */
function _initEnumConstant(container, enumcodes, callback) {
    var tc = $("#tonto_constant_value");
    if (tc.length > 0) {
        window._constant_cache = $.parseJSON(tc.text());
    }

    $.extend({
        // 获取常量
        getConstantEnum: function(enumcode) {
            if (enumcode) {
                return window._constant_cache[enumcode];
            }
        },
        getConstantEnumItem: function(enumcode, key) {
            var items = window._constant_cache[enumcode];
            if (items) {
                for (var i = 0; i < items.length; i++) {
                    if (items[i].key == key) {
                        return items[i];
                    }
                }
            }
            return null;
        },
        getConstantEnumValue: function(enumcode, key) {
            var items = window._constant_cache[enumcode];
            if (items) {
                for (var i = 0; i < items.length; i++) {
                    if (items[i].key == key) {
                        return items[i] && items[i].value;
                    }
                }
            }
            return null;
        }
    });

    // 下拉框
    var constants = container ? container.find(".tonto-select-constant") : $(".tonto-select-constant");
    constants.each(function() {
        var $s = $(this);
        var enumcode = $s.attr("enumcode");
        if (enumcode) {
            if ($s.is("select")) {
                var enumvalues = window._constant_cache[enumcode];
                if (enumvalues) {
                    enumvalues.forEach(function(a) {
                        $s.append("<option value='" + a.key + "'>" + a.value + "</option>");
                    });
                }
                var selectedvalue = $s.attr("selectedvalue");
                if (selectedvalue) {
                    if ($s.attr("multiple")) {
                        $s.val(selectedvalue.split(",")).trigger('change');;
                    } else {
                        $s.val(selectedvalue);
                    }
                }
            } else if ($s.is("p")) {
                var code = $s.attr("enum-code-value");
                if (code) {
                    $s.html($.getConstantEnumValue(enumcode, code) || "无");
                }
            }
        }
    });

    // 单选Radio
    constants = container ? container.find(".tonto-radio-constant") : $(".tonto-radio-constant");
    constants.each(function() {
        var $s = $(this);
        var enumcode = $s.attr("enumcode");
        if (enumcode) {
            var name = $s.attr("name") || $s.attr("id");
            var selectedvalue = $s.attr("selectedvalue");
            var enumvalues = window._constant_cache[enumcode];
            if (enumvalues) {
                var checked = false;
                enumvalues.forEach(function(a) {
                    if ((selectedvalue && selectedvalue == a.key) || (!selectedvalue && !checked)) {
                        $s.append('<label class="control-label radio-label"><input type="radio" checked="checked" name="' + name + '" value="' + a.key + '">&nbsp;&nbsp;' + a.value + '&nbsp;&nbsp;</label>');
                        checked = true;
                    } else {
                        $s.append('<label class="control-label radio-label"><input type="radio" name="' + name + '" value="' + a.key + '">&nbsp;&nbsp;' + a.value + '&nbsp;&nbsp;</label>');
                    }
                });
            }
        }
    });

    // 多选checkbox
    constants = container ? container.find(".tonto-checkbox-constant") : $(".tonto-checkbox-constant");
    constants.each(function() {
        var $s = $(this);
        var enumcode = $s.attr("enumcode");
        if (enumcode) {
            var name = $s.attr("name") || $s.attr("id");
            var selectedvalue = $s.attr("selectedvalue");
            if (selectedvalue) {
                selectedvalue = selectedvalue.split(",");
            }
            var enumvalues = window._constant_cache[enumcode];
            var isChecked = function(key) {
                if (selectedvalue) {
                    for (var i = 0; i < selectedvalue.length; i++) {
                        if (key == selectedvalue[i]) {
                            return true;
                        }
                    }
                }
                return false;
            }
            if (enumvalues) {
                enumvalues.forEach(function(a) {
                    if (isChecked(a.key)) {
                        $s.append('<label class="control-label radio-label"><input type="checkbox" checked="checked" name="' + name + '" value="' + a.key + '">&nbsp;&nbsp;' + a.value + '&nbsp;&nbsp;</label>');
                    } else {
                        $s.append('<label class="control-label radio-label"><input type="checkbox" name="' + name + '" value="' + a.key + '">&nbsp;&nbsp;' + a.value + '&nbsp;&nbsp;</label>');
                    }
                });
            }
        }
    });
}


/**
 * 加载form表单验证 <class = tonto-form-validate>
 */
function _initForm(container) {


    /**
     * 与ajax-form-submit结合处理子窗口提交form后回调（例如关闭子窗口并刷新父窗口表格）
     */
    $.extend({
        setLayerSubmitHandler: function(layero, index, submitSuccess, msg) {
            var forms = layer.getChildFrame('form', index);
            if (forms && forms.length > 0) {
                forms.each(function() {
                    $(this)[0].submitSuccessHandler = function(data) {
                        if (typeof submitSuccess == 'string') {
                            msg = submitSuccess;
                            submitSuccess = null;
                        }

                        if (msg) {
                            $.successMessage(msg);
                        }

                        if (submitSuccess) {
                            submitSuccess(data);
                        }
                    };
                });
            }
        }
    });

    $.fn.setFormSubmitHandler = function(submitSuccess, msg) {
        var form = $(this);

        if (typeof submitSuccess == 'string') {
            msg = submitSuccess;
            submitSuccess = null;
        }

        form[0].submitSuccessHandler = function(data) {
            if (msg) {
                $.successMessage(msg);
            }
            if (submitSuccess) {
                submitSuccess(data);
            }
        };
    };

    $.fn.createForm = function(formOptions, validateOptions) {
        var submitForm = $(this);
        var submitBtn = submitForm.find('button[type="submit"],input[type="submit"]')

        submitBtn.each(function() {
            var that = $(this);
            that.on('click', function(e) {
                if (that.data("loading")) {
                    return;
                }
                // ie处理placeholder提交问题
                if ($.browser && $.browser.msie) {
                    submitForm.find('[placeholder]').each(function() {
                        var $input = $(this);
                        if ($input.val() == $input.attr('placeholder')) {
                            $input.val('');
                        }
                    });
                }
                return true;
            });
        });

        var config = {
            debug: true,
            // 不要设置true，只有不想启用时候去设置false
            // 是否在获取焦点时验证
            onfocusout: false,
            // 在keyup时验证.
            onkeyup: false,
            // 当鼠标掉级时验证
            onclick: false,
            backurl: submitForm.attr("callback-url"),
            // 给未通过验证的元素加效果,闪烁等
            // highlight : false,
            showErrors: function(errorMap, errorList) {
                $.each(errorList, function(i, v) {
                    // 在此处用了layer的方法,显示效果更美观
                    layer.tips(v.message, v.element, { time: 2000, tips: [3, 'red'] });
                    return false;
                });
            }
        };

        if (formOptions) {
            if (typeof formOptions === 'function') {
                config.formOptions = {
                    successCallback: formOptions
                }
            } else if (typeof formOptions === 'object') {
                config.formOptions = formOptions;
            }
        }

        if (validateOptions) {
            if (typeof validateOptions === 'object') {
                config = $.extend(config, validateOptions);
            }
        }

        config.submitHandler = function(a) {
            var form = $(a);
            var formConfig = {
                url: submitBtn.data('action') ? submitBtn.data('action') : form.attr('action'),
                dataType: 'json',
                type: 'post',
                beforeSubmit: function(arr, $form, options) {
                    submitBtn.each(function() {
                        var that = $(this);
                        that.data("loading", true);
                        var text = that.text();
                        that.data("orginText", text);
                        that.text(text + '中...').prop('disabled', true).addClass('disabled');
                    });

                    if (typeof formConfig.beforeCallback === 'function') {
                        return formConfig.beforeCallback(arr, $form, options);
                    }
                },
                success: function(data) {
                    submitBtn.each(function() {
                        var that = $(this);
                        var text = that.text();
                        that.removeClass('disabled').prop('disabled', false).text(that.data("orginText"));
                    });

                    var resStatus = data.status,
                        status = _RESPONSE_STATUS;

                    if (status.NO_LOGIN === resStatus) {
                        ajaxUnLoginHandler(form.data("submitSuccessHandler"));
                    } else if (status.NO_PERMISSION === resStatus) {
                        $.errorMessage(data.message || "您没有权限访问该页面或执行该操作");
                    } else if (status.ERROR === resStatus) {
                        $.errorMessage(data.message || "访问页面或执行操作错误");
                    } else if (status.FAIL === resStatus) {
                        $.errorMessage(data.message || "操作失败");
                    } else if (status.FAIL_VALID === resStatus) {
                        $.validErrorHandler(data);
                    } else if (status.SUCCESS === resStatus) {
                        var handler = formConfig.successCallback || form[0].submitSuccessHandler || form.data("submitSuccessHandler");
                        if (handler) {
                            handler(data.result ? data.result : data);
                        } else {
                            if (config.backurl) {
                                layer.alert("操作成功", function(index) {
                                    layer.close(index);
                                    window.location = config.backurl;
                                });
                            }
                        }
                    } else {
                        $.errorMessage("返回数据格式异常");
                    }
                },
                error: function(xhr, e, statusText) {
                    $.errorMessage("系统异常");
                },
                complete: function() {
                    submitBtn.data("loading", false);
                }
            };

            if (config.formOptions) {
                formConfig = $.extend(formConfig, config.formOptions);
            }

            form.ajaxSubmit(formConfig);
        }

        submitForm.createFormValidater(config);
    }

    var forms = container ? $(container).find(".tonto-form-validate") : $(".tonto-form-validate");

    forms.each(function() {
        var submitForm = $(this);
        submitForm.createForm();
    });
}


// ------------------------------------------
//
// 附件处理
//
// -----------------------------------------

function _initAttachment() {
    $.extend({
        loadAttachment: function(id, callback) {
            $.getAjax("/common/attachment/" + id, function(data) {
                if (typeof callback === 'function') {
                    callback($.parseAttachmentData(data));
                }
            });
        },
        loadAttachments: function(ids, callback) {
            $.postAjax("/common/attachment", { id: ids }, function(data) {
                var result = {};
                if (data && data.length > 0) {
                    data.forEach(function(i) {
                        result[i.id] = $.parseAttachmentData(i);
                    });
                }
                if (typeof callback === 'function') {
                    callback(result);
                }
            });
        },
        parseAttachmentData(data) {
            if (data) {
                if ($.isArray(data)) {
                    var result = [];
                    data.forEach(function(item) {
                        result.push({
                            id: item.id,
                            name: item.name,
                            filename: item.name + item.suffix,
                            url: "/file/" + item.pelativePath,
                            size: item.size,
                            type: item.type
                        });
                    });
                    return result;
                } else {
                    return [{
                        id: data.id,
                        name: data.name,
                        filename: data.name + data.suffix,
                        url: "/file/" + data.pelativePath,
                        size: data.size,
                        type: data.type
                    }]
                }
            }
            return null;
        }
    });
}

// ------------------------------------------
//
// AjaxUploadFile
//
// -----------------------------------------

function ajaxUploadFile(files, successCallback, submitBtn) {
    if (files) {
        if (!$.isArray(files)) {
            files = [files];
        }

        if (files.length > 0) {
            var formData = new FormData();
            files.forEach(function(file) {
                formData.append('files', file);;
            });

            var success = $.wrapAjaxSuccessCallback(successCallback, submitBtn);

            $.ajax({
                url: "/common/upload/files",
                type: "POST",
                data: formData,
                processData: false, // 告诉jQuery不要去处理发送的数据
                contentType: false, // 告诉jQuery不要去设置Content-Type请求头
                success: success,
                error: function(xhr, e) {
                    $.errorMessage("系统异常:" + xhr.status);
                }
            });
        }
    }
}


// ------------------------------------------
//
// 常用工具方法
//
// -----------------------------------------

/*
 * 时间格式化工具 
 * 把Long类型的1527672756454日期还原yyyy-MM-dd 00:00:00格式日期   
 */
function datetimeFormat(longTypeDate) {
    var dateTypeDate = "";
    var date = new Date();
    date.setTime(longTypeDate);
    dateTypeDate += date.getFullYear(); //年    
    dateTypeDate += "-" + getMonth(date); //月     
    dateTypeDate += "-" + getDay(date); //日    
    dateTypeDate += " " + getHours(date); //时    
    dateTypeDate += ":" + getMinutes(date); //分  
    dateTypeDate += ":" + getSeconds(date); //分  
    return dateTypeDate;
}
/*  
 * 时间格式化工具 
 * 把Long类型的1527672756454日期还原yyyy-MM-dd格式日期   
 */
function dateFormat(longTypeDate) {
    var dateTypeDate = "";
    var date = new Date();
    date.setTime(longTypeDate);
    dateTypeDate += date.getFullYear(); //年    
    dateTypeDate += "-" + getMonth(date); //月     
    dateTypeDate += "-" + getDay(date); //日    
    return dateTypeDate;
}
//返回 01-12 的月份值     
function getMonth(date) {
    var month = "";
    month = date.getMonth() + 1; //getMonth()得到的月份是0-11    
    if (month < 10) {
        month = "0" + month;
    }
    return month;
}
//返回01-30的日期    
function getDay(date) {
    var day = "";
    day = date.getDate();
    if (day < 10) {
        day = "0" + day;
    }
    return day;
}
//小时  
function getHours(date) {
    var hours = "";
    hours = date.getHours();
    if (hours < 10) {
        hours = "0" + hours;
    }
    return hours;
}
//分  
function getMinutes(date) {
    var minute = "";
    minute = date.getMinutes();
    if (minute < 10) {
        minute = "0" + minute;
    }
    return minute;
}
//秒  
function getSeconds(date) {
    var second = "";
    second = date.getSeconds();
    if (second < 10) {
        second = "0" + second;
    }
    return second;
}

function hideIdentification(value) {
    if (value) {
        var l = value.length;
        if (l > 7) {
            var s = value.substr(0, 3);
            var a = value.length - 7;
            for (; a > 0; a--) s += "*";
            s += value.substr(value.length - 4, 4);
            return s;
        } else {
            return value;
        }
    }
    return "";
}

function omitString(str, length) {
    if (str && str.length > length) {
        return str.substring(0, length) + "...";
    }
    return str;
}