package helloworld;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.net.URL;
import java.util.HashMap;
import java.util.Map;
import java.util.stream.Collectors;

import com.amazonaws.services.lambda.runtime.LambdaLogger;
import org.json.JSONArray;
import org.json.JSONObject;
import com.amazonaws.services.lambda.runtime.Context;
import com.amazonaws.services.lambda.runtime.RequestHandler;
import com.amazonaws.services.lambda.runtime.events.APIGatewayProxyRequestEvent;
import com.amazonaws.services.lambda.runtime.events.APIGatewayProxyResponseEvent;
import com.fasterxml.jackson.databind.util.JSONPObject;

/**
 * Handler for requests to Lambda function.
 */
public class App implements RequestHandler<APIGatewayProxyRequestEvent, APIGatewayProxyResponseEvent> {


    String secretKey = "[imported from files]";
    String accessKey = "[imported from files]";



    public APIGatewayProxyResponseEvent handleRequest(final APIGatewayProxyRequestEvent input, final Context context) {
        Map<String, String> headers = new HashMap<>();
        headers.put("Content-Type", "application/json");
        headers.put("X-Custom-Header", "application/json");


        LambdaLogger l = context.getLogger();

        l.log("Raw Input Data: " + input.getBody());

        JSONObject data = new JSONObject(input.getBody());

        l.log("\nProcessed Input Data: " + data);


        if(data.getString("function").equals("login"))
            return checkLogin(input, context);
        if(data.getString("function").equals("upload"))
            return uploadData(input, context);
        if(data.getString("function").equals("get_nicknames"))
            return getNicknames(input, context);
        if(data.getString("function").equals("get_data"))
            return getData(input, context);


        APIGatewayProxyResponseEvent response = new APIGatewayProxyResponseEvent()
                .withHeaders(headers);
        try {
            final String pageContents = this.getPageContents("https://checkip.amazonaws.com");
            String output = String.format("{ \"message\": \"hello world\", \"location\": \"%s\" }", pageContents);

            return response
                    .withStatusCode(200)
                    .withBody(output);
        } catch (IOException e) {
            return response
                    .withBody("{}")
                    .withStatusCode(500);
        }
    }


    public APIGatewayProxyResponseEvent checkLogin(final APIGatewayProxyRequestEvent input, final Context context) {

        Map<String, String> headers = new HashMap<>();
        headers.put("Content-Type", "application/json");
        headers.put("X-Custom-Header", "application/json");


        DbHelper dbHelper = new DbHelper(accessKey, secretKey);

        LambdaLogger l = context.getLogger();


        l.log("\nLogging in");


        //l.log("Raw Input Data: " + input.getBody());

        JSONObject data = new JSONObject(input.getBody());


        //l.log("Processed Input Data: " + data);


        String password = data.getString("password");
        String username = data.getString("username");


        boolean loginResult = dbHelper.authUser(username, password);


        APIGatewayProxyResponseEvent response = new APIGatewayProxyResponseEvent()
                .withHeaders(headers);
        try {
            final String pageContents = this.getPageContents("https://checkip.amazonaws.com");
            String output = String.format("{ \"result\": \"%s\"}", loginResult);

            return response
                    .withStatusCode(200)
                    .withBody(output);
        } catch (IOException e) {
            return response
                    .withBody("{}")
                    .withStatusCode(500);
        }

    }

    public APIGatewayProxyResponseEvent uploadData(final APIGatewayProxyRequestEvent input, final Context context) {

        Map<String, String> headers = new HashMap<>();
        headers.put("Content-Type", "application/json");
        headers.put("X-Custom-Header", "application/json");


        DbHelper dbHelper = new DbHelper(accessKey, secretKey);

        LambdaLogger l = context.getLogger();
        JSONObject data = new JSONObject(input.getBody());

        String nickname = data.getString("nickname");
        String username = data.getString("username");
        String uploadedData = data.getString("data");

        boolean uploadResult = dbHelper.uploadData(username,nickname, uploadedData);




        APIGatewayProxyResponseEvent response = new APIGatewayProxyResponseEvent()
                .withHeaders(headers);
        try {
            final String pageContents = this.getPageContents("https://checkip.amazonaws.com");
            String output = String.format("{ \"result\": \"%s\"}", uploadResult);

            return response
                    .withStatusCode(200)
                    .withBody(output);
        } catch (IOException e) {
            return response
                    .withBody("{}")
                    .withStatusCode(500);
        }

    }


    public APIGatewayProxyResponseEvent getNicknames(final APIGatewayProxyRequestEvent input, final Context context) {

        Map<String, String> headers = new HashMap<>();
        headers.put("Content-Type", "application/json");
        headers.put("X-Custom-Header", "application/json");


        DbHelper dbHelper = new DbHelper(accessKey, secretKey);

        LambdaLogger l = context.getLogger();
        JSONObject data = new JSONObject(input.getBody());

        String username = data.getString("username");

        JSONArray nicknameList = dbHelper.getNicknames(username);




        APIGatewayProxyResponseEvent response = new APIGatewayProxyResponseEvent()
                .withHeaders(headers);
        try {
            final String pageContents = this.getPageContents("https://checkip.amazonaws.com");
            String output = String.format("{ \"result\": %s}", nicknameList);

            return response
                    .withStatusCode(200)
                    .withBody(output);
        } catch (IOException e) {
            return response
                    .withBody("{}")
                    .withStatusCode(500);
        }

    }


    public APIGatewayProxyResponseEvent getData(final APIGatewayProxyRequestEvent input, final Context context) {

        Map<String, String> headers = new HashMap<>();
        headers.put("Content-Type", "application/json");
        headers.put("X-Custom-Header", "application/json");


        DbHelper dbHelper = new DbHelper(accessKey, secretKey);

        LambdaLogger l = context.getLogger();
        JSONObject data = new JSONObject(input.getBody());

        String username = data.getString("username");
        String nickname = data.getString("nickname");

        String outputData = dbHelper.getData(username, nickname);




        APIGatewayProxyResponseEvent response = new APIGatewayProxyResponseEvent()
                .withHeaders(headers);
        try {
            final String pageContents = this.getPageContents("https://checkip.amazonaws.com");
            String output = String.format("{ \"result\": \"%s\"}", outputData);

            return response
                    .withStatusCode(200)
                    .withBody(output);
        } catch (IOException e) {
            return response
                    .withBody("{}")
                    .withStatusCode(500);
        }

    }

    private String getPageContents(String address) throws IOException{
        URL url = new URL(address);
        try(BufferedReader br = new BufferedReader(new InputStreamReader(url.openStream()))) {
            return br.lines().collect(Collectors.joining(System.lineSeparator()));
        }
    }
}
