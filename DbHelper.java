package helloworld;

import com.amazonaws.AmazonServiceException;
import com.amazonaws.auth.AWSStaticCredentialsProvider;
import com.amazonaws.auth.BasicAWSCredentials;
import com.amazonaws.regions.Regions;
import com.amazonaws.services.dynamodbv2.AmazonDynamoDB;
import com.amazonaws.services.dynamodbv2.AmazonDynamoDBClientBuilder;
import com.amazonaws.services.dynamodbv2.document.Item;
import com.amazonaws.services.dynamodbv2.document.Table;
import com.amazonaws.services.dynamodbv2.document.TableWriteItems;
import com.amazonaws.services.dynamodbv2.document.spec.DeleteItemSpec;
import com.amazonaws.services.dynamodbv2.model.*;
import com.amazonaws.services.dynamodbv2.xspec.S;
import com.amazonaws.services.lambda.runtime.LambdaLogger;


import com.amazonaws.auth.AWSStaticCredentialsProvider;
import com.amazonaws.auth.BasicAWSCredentials;
import com.amazonaws.regions.Regions;
import com.amazonaws.services.dynamodbv2.AmazonDynamoDB;
import com.amazonaws.services.dynamodbv2.AmazonDynamoDBClientBuilder;
import com.amazonaws.services.dynamodbv2.datamodeling.DynamoDBMapper;
import com.amazonaws.services.dynamodbv2.document.*;
import com.amazonaws.services.dynamodbv2.document.spec.GetItemSpec;
import com.amazonaws.services.dynamodbv2.document.spec.QuerySpec;
import com.amazonaws.services.dynamodbv2.document.utils.ValueMap;
import com.amazonaws.services.dynamodbv2.model.AttributeValue;
import com.amazonaws.services.dynamodbv2.model.ExecuteStatementRequest;
import com.amazonaws.services.dynamodbv2.model.ExecuteStatementResult;
import com.amazonaws.services.lambda.runtime.LambdaLogger;
import org.json.JSONArray;

import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.time.Instant;
import java.util.*;


public class DbHelper {


    AmazonDynamoDB dynamoDB;

    DynamoDB readDynamoDB;

    public DbHelper(String accessKey, String secretKey) {

        this.dynamoDB = AmazonDynamoDBClientBuilder.standard()
                .withRegion(Regions.US_WEST_1)
                .withCredentials(new AWSStaticCredentialsProvider
                        (new BasicAWSCredentials(accessKey, secretKey)))
                .build();
        this.readDynamoDB = new DynamoDB(dynamoDB);

    }


    public boolean authUser(String username, String password) {

        Table table = readDynamoDB.getTable("formulaUsers");


        QuerySpec querySpec = new QuerySpec();

        GetItemSpec spec = new GetItemSpec()
                .withPrimaryKey("username", username);


        Item item = table.getItem(spec);

        if (item == null) {
            return false;
        }

        return item.getString("password").equals(password);


    }


    public boolean uploadData(String username, String nickname, String data){
        PutItemRequest request = new PutItemRequest();

        if(nickname == null || username == null || data == null){
            return false;
        }

        //table name = users
        request.setTableName("uploadData");

        Map<String, AttributeValue> push = new HashMap<>();

        push.put("username", new AttributeValue(username));
        push.put("nickname", new AttributeValue(nickname));
        push.put("data", new AttributeValue(data));
        //data.put("username", new AttributeValue(username));

        request.setItem(push);

        try {
            //pushing the data
            dynamoDB.putItem(request);
        }
        catch (AmazonServiceException e){
            return false;
        }
        return true;
    }


    public JSONArray getNicknames(String username){
        PutItemRequest request = new PutItemRequest();

        if(username == null){
            return null;
        }

        //table name = users
        Table table = readDynamoDB.getTable("uploadData");

        QuerySpec spec = new QuerySpec()
                .withKeyConditionExpression("username = :v_id")
                .withValueMap(new ValueMap()
                        .withString(":v_id", username));

        ItemCollection<QueryOutcome> items = table.query(spec);

        JSONArray response = new JSONArray();

        for (Item item: items) {
            response.put(item.getString("nickname"));

        }

        return response;

    }

    public String getData(String username, String nickname){

        GetItemRequest getItemRequest = new GetItemRequest().withTableName("uploadData").
                addKeyEntry("username", new AttributeValue().withS(String.valueOf(username))).
                addKeyEntry("nickname", new AttributeValue().withS(String.valueOf(nickname)));

        Map<String, AttributeValue> responseItem = dynamoDB.getItem(getItemRequest).getItem();

        String response = responseItem.get("data").getS();
        return response;
    }
}