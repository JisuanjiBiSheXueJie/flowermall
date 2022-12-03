package com.daowen.util;

import com.alipay.api.AlipayApiException;
import com.alipay.api.AlipayClient;
import com.alipay.api.DefaultAlipayClient;
import com.alipay.api.internal.util.AlipaySignature;
import com.alipay.api.request.AlipayTradePagePayRequest;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.UnsupportedEncodingException;
import java.security.SecureRandom;
import java.util.HashMap;
import java.util.Map;


public class AlipayUtil {



    private final String APP_ID = "2016091300504379";

    private final String ALIPAY_PUBLIC_KEY="MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAp2vE/iQ01uIH+IyML07iARpglpWuJUIsQZAesj8vh0MXxTBzOSrMUCndrA8lrSoY61Jni921K3jH8gH0p9iGZlFbm8uSAsXnHH1jhLWgSAxzBa2+wiAJ3A0v2CIypONSmzrdtgUBD6A4PMwJOBN1H73U7GUVQpctobM3sVJ9AtWnuxMls/9Naox/I3ANGzZlTPxFvxxQjBwUSXI8nY8rjJOXjdb3CFurMMP/dV7I23tyaFFUQeKICJNWMKzDILJ7xntvkwM20zY8dwSiYISc1waU4BAIHJcDtvQsY/d3zaWviLCk+pFy7j9qhM2N4rr+M7He4Cbd7nqaz1O2F86adQIDAQAB";
    private final String APP_PRIVATE_KEY = "MIIEvwIBADANBgkqhkiG9w0BAQEFAASCBKkwggSlAgEAAoIBAQC1OQBO5rgfy+gGLHXfG3o68ZWGqRUhFAgtu0IJwTLk0DBH5tF2kzBJIe4shGW90eb0KUeiSkTKiaflzmj3DrxIuDODtYDijdsyQWJUU60HoiebMTkujDR19OWBZ8M8wOQY6LvSsxmh2Y6A27rUtgHhyAR5zapamEzFPipEemUudEQ3pJbBoD5HPgPbfF2XJfKnlKQZs20vWqn1NoKlVgFUjBGJUAgblX6GimDvDySoTuHotutekii54pWAFoFIspWJWE7m/V97V+MWOaftMrVQJFt5RoGawJ7xyD+wvL9A7PwV+C3yTTraGV4bqc1Tjf9DUC5GGtvKFKs8J53ksDNBAgMBAAECggEBAKQsJm5UL5uGkwT8xC/BacL6VrZueNjFl/8t9E53+s41GHgaz8l24Dhwh59GthD3lh29Q8rvM1C00iirDIY8kC/kx65bAI69akUl3Jl+UHNo4C6EskPL+j6eBEhuIv3n1PwH4xem7uKj/6gW5zOKSzwqgnuB6QE3ldzeS1ZL91vTqm1hpA13OIzwsCYQC9tldGqJ5zFXg5w8Eo80xDp7KZkfz9jLuGGZc34uKxXyW4FXdzPGS/s9NFuwEvcYygfI14ndB8wrQscV8k69EBl57sHcpBP9fMO6J3AAd0A5gN7FRayQNcx0ATxcl+gz0qYqCIubRlVmcDWr7y1q+nE9NB0CgYEA7O0tXEy6y1wx2azZhhdNEE5M7tCDWcTsrlPziqZhMlyHuY+jX3IvkhErPt8tQhrXHwLz2mTx9WYw5Gx1kLuekbW0YTNdLacxkh9Ue2wa1vB3pGPoKhMBaOpsw9cOBLODrbVpqYz3zoLou7MFQZCH96vvcO6cc/y5IaKn62Vay9sCgYEAw8/SrC+f+vT6CqaKK2x4/kopTDV5pkQjJIf3fe0DTfyTwJMGDT9kPMF116+k0ph+TwcliZsgROGKMTHLqljZW/Q355uug7xI38vlSWICQsfi8zs4UQxw1ET1B0NVQLGG5qJh2DqI8D5PrKVhg6a3rg+r06cdCVmm+WwPRkS+1hMCgYEAmFXfZotHR14eB1GmAxuURzmxKZQUAHIno+cCnlFgCVuJQPxkFQh8IbS8U453sRtE2gGx/OgO0rREF3rNFKQtzo5ATocSEDqCGuveDAV0NGMk6iP6sKLLs0OXb0wlDUzHC7erGoMzCisNrTHr3T4qzkpUiA5Dtif2ePP2d9oRSSUCgYEAvoFmNRGMsys+TbhjuwWo3bYnYbaxKRsnmbYTCtfaHDi9Q2GHRMJE8ntB/Fstn5qvYJHSaoObLIjF20DYJl6U8kqzTUmAyzgXKm0EIZYSHwi7++rEys2wxERmo+9VdUCCv8aCLU4dxqbI+25XZi+Aiv9CLARtUph/xDDm13WwuTMCgYAseLlZ6arMkwbE+tWlHeVB02jRhPKdXkZ/XdeZqZWq9cyWKggH/L7mKpY0h8NSEVv8tLcZ01p0JzZnBfAHIiqsC6HoH1Tz9Qqmzlg6TStnI8QiiNToJThQSzqWj4sm81j+0sR4oiUKcHGg762Q/g+8p7iJTh3bH2qUUpK55JJG/Q==";
    private final String CHARSET = "UTF-8";
    private final String APP_PUBLIC_KEY = "MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAmyqDK7pgW1bBYiRcF2gF9FeSW27YjqyK8u6OeHK8LIAKg5WcJNvYREQQ34TdmIEuzqN22zO2fyLxi/RPu6SSOFvbI+WvV/BdKIERvc5B4EiI9U7cr3YIesiDsLhDob60OBedP4pZArdFq58GzbHFALCBMA34JF4NTMYGaVAxQSF/uM4PeBGSaFWqGZQviik+hN1tbMYxu0+kOyIo4r60CaW/Spt/IT8OJf7gm0Rrn6V+fDZ51kR0bU9dr/clirKCPh+ugxEohzplzjCnLOhcsBlKyvHSAYJxFGpJtFzTXTW5fFHNkz1tRy50diSqvEC2zYVBFqySrQgo8bUc6zAXcwIDAQAB";
    private final String GATEWAY_URL ="https://openapi.alipaydev.com/gateway.do";
    private final String FORMAT = "JSON";
    //签名方式
    private final String SIGN_TYPE = "RSA2";

    private  final  String server="http://localhost:8080";

    private HttpServletRequest request;
    private HttpServletResponse response;
    public AlipayUtil(HttpServletRequest request,HttpServletResponse response){
        this.request=request;
        this.response=response;
    }

    public static class PaymentOrder{
        private String title;
        private String amount;
        private String orderno;

        private String returnurl;

        private String notifyurl;

        public String getNotifyurl() {
            return notifyurl;
        }

        public void setNotifyurl(String notifyurl) {
            this.notifyurl = notifyurl;
        }

        public String getReturnurl() {
            return returnurl;
        }

        public void setReturnurl(String returnurl) {
            this.returnurl = returnurl;
        }

        public PaymentOrder(String title, String amount, String orderno) {
            this.title = title;
            this.amount = amount;
            this.orderno = orderno;
        }

        public String getOrderno() {
            return orderno;
        }

        public void setOrderno(String orderno) {
            this.orderno = orderno;
        }

        public String getTitle() {
            return title;
        }

        public void setTitle(String title) {
            this.title = title;
        }

        public String getAmount() {
            return amount;
        }

        public void setAmount(String amount) {
            this.amount = amount;
        }
    }

    public void pay(PaymentOrder order){

        if(order==null)
            return;
        SecureRandom r= new SecureRandom();

        AlipayClient alipayClient = new DefaultAlipayClient(GATEWAY_URL, APP_ID, APP_PRIVATE_KEY, FORMAT, CHARSET, APP_PUBLIC_KEY, SIGN_TYPE);
        AlipayTradePagePayRequest request = new AlipayTradePagePayRequest();
        String returnurl=this.server+this.request.getContextPath()+"/payreturn";
        String notifyurl=  this.server+this.request.getContextPath()+"/notifyUrl";
        if(order.returnurl!=null)
            returnurl=order.returnurl;
        if(order.notifyurl!=null)
            notifyurl=order.notifyurl;
        request.setReturnUrl(returnurl);
        request.setNotifyUrl(notifyurl);
        request.setBizContent("{\"out_trade_no\":\""+ order.orderno +"\","
                + "\"total_amount\":\""+ order.amount +"\","
                + "\"subject\":\""+ order.title +"\","
                + "\"body\":\""+ order.title +"\","
                + "\"product_code\":\"FAST_INSTANT_TRADE_PAY\"}");
        String form = "";
        try {
            form = alipayClient.pageExecute(request).getBody();
        } catch (AlipayApiException e) {
            e.printStackTrace();
        }
        response.setContentType("text/html;charset=" + CHARSET);
        try {
            response.getWriter().write(form);
            response.getWriter().flush();
            response.getWriter().close();
        }catch (Exception e){

        }
    }

    public String getOrderno(){
        return request.getParameter("out_trade_no");
    }
    public String getAmount(){
        return request.getParameter("total_amount");
    }
    public boolean validate(){

        try {
            request.setCharacterEncoding("utf-8");//乱码解决，这段代码在出现乱码时使用
        } catch (UnsupportedEncodingException e) {
            e.printStackTrace();
        }
        Map<String,String> params = new HashMap<String,String>();
        Map<String,String[]> requestParams = request.getParameterMap();
        for(String str :requestParams.keySet()){
            String name = str;
            String[] values = (String[]) requestParams.get(name);
            String valueStr = "";
            for (int i = 0; i < values.length; i++) {
                valueStr = (i == values.length - 1) ? valueStr + values[i]
                        : valueStr + values[i] + ",";
            }
            params.put(name, valueStr);
        }
        try {
            return AlipaySignature.rsaCheckV1(params, ALIPAY_PUBLIC_KEY, CHARSET, "RSA2"); //调用SDK验证签名
        } catch (AlipayApiException e) {
            e.printStackTrace();
        }
        return false;

    }

}
