/**验证工具集合**/
let validateUtil = {

    required: function (data) {

        if (data == null) {
            return false
        }

        if (parseFloat(data).toString() != "NaN") {
            return true
        }

        if ((typeof data) == 'object') {
            if (data.length > 0) {
                return true
            } else {
                return false
            }
        }

        data = data.replace(/\s+/g, "")

        if (data != '' && data != null && data != undefined) {
            return true
        }

        return false
    },
    maxlength: function (data, len) {
        if (data.length <= len) {
            return true
        }
        return false
    },
    minlength: function (data, len) {
        if (data.length >= len) {
            return true
        }
        return false
    },
    mobile: function (data) {
        let mobile = /^(13[0-9]{9})|(18[0-9]{9})|(14[0-9]{9})|(17[0-9]{9})|(15[0-9]{9})$/;
        return mobile.test(data)
    },
    email: function (data) {
        let email = /^[a-zA-Z0-9_-]+@[a-zA-Z0-9_-]+(\.[a-zA-Z0-9_-]+)+$/
        return email.test(data)
    },
    number: function (data) {
        let number = /^[0-9]+(.[0-9]+)?$/
        return number.test(data)
    },
    min: function (data, number) {
        if (data >= number) {
            return true
        }
        return false
    },
    max: function (data, number) {
        if (data <= number) {
            return true
        }
        return false
    },
    /**
     * 身份证
     * @param data
     * @returns {boolean}
     */
    idcardno: function (data) {
        let check = /^[1-9]\d{5}[1-9]\d{3}((0[1-9])|(1[0-2]))((0[1-9])|([1-2][0-9])|(3[0-1]))\d{3}(\d|x|X)$/.test(data);
        return check;
    }

};
const messages = {
    required: "请输入必填字段",
    maxlength: "您最多可输入{0}个字符.",
    minlength: "您最少可输入{0}个字符.",
    mobile: "请输入正确的手机号",
    email: "请输入正确的邮箱",
    number: '请输入正确的数字',
    min: '最小值不能小于{0}',
    max: '最大值不能超过{0}',
}


/**
 * 验证器
 * @type {{valid(): boolean, items: {}, errors: {}}}
 */

HTMLElement.prototype.appendHTML = function (html) {
    let divTemp = document.createElement("div"),
        nodes = null
        // 文档片段，一次性append，提高性能
        , fragment = document.createDocumentFragment();
    divTemp.innerHTML = html;
    nodes = divTemp.childNodes;
    for (let i = 0, length = nodes.length; i < length; i += 1) {
        fragment.appendChild(nodes[i].cloneNode(true));
    }
    this.appendChild(fragment);
    // 据说下面这样子世界会更清净
    nodes = null;
    fragment = null;
};
/**
 *
 * @constructor
 */
let MyValidator=function(vue,options){
    vue.validateOptions={
        isShowErrors:true
    };
    Object.assign(vue.validateOptions,options);
    console.log("options",vue.validateOptions);
    let scope=vue;
    this.vue=vue;
    this.valid=function() {

        if(MyValidator.items == null || MyValidator.items.length == 0)
            return true;
        //设置vue实例
        scope.errors = {};
        for (let key in MyValidator.items) {
            let it = MyValidator.items[key];
            if (it == null)
                continue;
            let rule = it.rule;
            let dom = it.dom;

            for (let type in rule) {
                this.validate.call(scope, key, type);
            }
            if (this.vue.validateOptions.isShowErrors) {
                this.showErrorMsgs(key);
            }

        }

        return propCount(scope.errors) == 0;
    };
    /**验证**/
    this.validate=function(name, type) {

        if (this.errors == null) {
            this.errors = {};
            console.log("设置错误");
        }
        //清除错误记录
        if (this.errors[name] != null && this.errors[name][type] != null) {
            this.$delete(this.errors[name], type);
            let count = propCount(this.errors[name]);
            if (count == 0)
                this.$delete(this.errors, name);
        }

        let it = MyValidator.items[name];
        console.log("items", MyValidator.items);
        console.log("it=", it);
        let rule = it == null ? null : it.rule;
        let val = it.dom.value;
        let typeVal = rule[type];
        let invokeMethod = validateUtil[type];
        Object.assign(messages, it.rule.messages);
        if (invokeMethod && !invokeMethod(val, typeVal)) {

            if (this.errors[name] != null)
                Vue.set(this.errors[name], type, messages[type]);
            //this.errors[name][type] = messages[type];
            else {
                Vue.set(this.errors, name, {});
                Vue.set(this.errors[name], type, messages[type]);
                // let obj = {};
                // obj[type] = messages[type];
                // this.errors[name] = obj;
            }

        }
        console.log("this.errors=", this.errors);

    };

    let propCount=function(obj) {
        let count = 0;
        for (let key in obj) {
            if (obj.hasOwnProperty(key)) {
                count++;
            }
        }
        return count;
    };
    /**
     * 显示错误消息
     * @param key
     */
    this.showErrorMsgs=function(key){

        let instance=this.vue;
        if (instance==null||key==null)
            return;
        if (instance.errors==null){
            console.log("请设置errors");
            return;
        }
        if (MyValidator.items[key]==null){
            console.log("没有找到相关dom");
            return;
        }
        let el=MyValidator.items[key].dom;
        if (instance.errors[key] != null) {
            for (let type in instance.errors[key]) {
                let selector = `[name=${key}_${type}]`;
                let errorLabels = el.parentNode.querySelectorAll(selector);
                //存在错误则添加提示
                if (errorLabels.length == 0 && instance.errors[key][type] != null) {
                    let errorCon = `<label name="${key}_${type}"   class="error">${instance.errors[key][type]}</label>`;
                    el.parentNode.appendHTML(errorCon);
                }else{
                    ///不存在错误 并且有错误提示则移除
                    if(instance.errors[key][type] ==null&&errorLabels.length>0){
                        for (let i = 0; i < errorLabels.length; i++) {
                            el.parentNode.removeChild(errorLabels[i]);
                        }
                    }
                }

            }
        } else {
            let it=MyValidator.items[key];
            for (let type in it.rule) {

                let selector = `[name=${key}_${type}]`;
                let errorLabels = el.parentNode.querySelectorAll(selector);
                for (let i = 0; i < errorLabels.length; i++) {
                    el.parentNode.removeChild(errorLabels[i]);
                }
            }

        }


    };

    let hasError =function(name, type) {
        if (name == null)
            return false;
        if (type == null)
            return this.errors[name];
        if (this.errors[name] != null)
            return this.errors[name][type];
        return false;
    };
    let errMsg= function(name, type) {
        if (name == null)
            return "";
        if (type == null)
            return this.errors[name];
        if (this.errors[name] != null) {
            console.log("this.errors[name][type]=", this.errors[name][type])
            return this.errors[name][type];
        }
        return "";
    };

}
MyValidator.items={};

Vue.prototype.myValidator = {

    valid(scope,options) {
       if (scope==null){
           console.log("实例不正确");
           return false;
       }
       return new MyValidator(scope,options).valid();
    },
    addMethod(name,callback){
        validateUtil[name]=callback;
    }
};

Vue.directive('validate', {


    inserted: function (el, binding, vnode) {

        //console.log("开始插入");
        let instance = vnode.context;
        if (instance && instance.errors == null) {
            console.log("初始化errors")
            instance.errors = {};

        }

        let it = {dom: el};
        //console.log("el=",el);
        let eleName = "dom";
        let index = 0;
        if (el.name != null)
            eleName = el.name;
        if (binding.value != null && binding.value.toString.call(binding.value) === '[object Object]')
            it.rule = binding.value;//设置验证规则
        //自定义元素名称
        while (index++) {
            if (MyValidator.items[eleName] != null)
                eleName += index;
            break;
        }
        // 设置校验元素
        MyValidator.items[eleName] = it;

        el.addEventListener('keyup', function (event) {

            let key = el.name;
            console.log("it.rule=", it.rule);
            for (let type in it.rule) {
                if (type == "messages" || validateUtil[type] == null)
                    continue;
               new  MyValidator(instance).validate.call(instance, el.name, type);
            }

            if (instance.validateOptions.isShowErrors){
                new MyValidator(instance).showErrorMsgs(key);
            }
        });

        // el.addEventListener("blur",function (event){
        //     for(let type in it.rule){
        //         if(validateUtil[type]==null)
        //             continue;
        //         Vue.prototype.myValidator.validate(instance,el.name,type)
        //     }
        //     //console.log("失去焦点值=",el.value);
        //     //Vue.prototype.myValidator.testmsg=el.value;
        // });

    }
})
