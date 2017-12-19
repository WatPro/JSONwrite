import com.mongodb.MongoClient;
// import com.mongodb.MongoClientURI;
// import com.mongodb.ServerAddress;

import com.mongodb.client.MongoDatabase;
import com.mongodb.client.MongoCollection;
import com.mongodb.client.FindIterable;

import org.bson.Document;
import org.bson.conversions.Bson; 
import java.util.Iterator; 
import java.util.Arrays;
import com.mongodb.Block;

import com.mongodb.client.MongoCursor;
import static com.mongodb.client.model.Filters.*;
import com.mongodb.client.result.DeleteResult;
import static com.mongodb.client.model.Updates.*;
import com.mongodb.client.result.UpdateResult;
import java.util.ArrayList;
import java.util.List;

public class TestCollection {
    private MongoClient mongoClient; 
    private MongoDatabase database;
    private MongoCollection<Document> collection; 
    public TestCollection(final String host, final int port, final String databaseName, final String name) {
        MongoClient mongoClient = new MongoClient( host, port ); 
        MongoDatabase database = mongoClient.getDatabase( databaseName ); 
        collection = database.getCollection( name );
    }
    public TestCollection() { 
        this( "localhost", 27017, "testdb", "birthday" ); 
    }
    public Iterator find() {
        FindIterable findIterable = collection.find(); 
        return findIterable.iterator();
    }
    public Iterator find(Bson filter) {
        FindIterable findIterable = collection.find(filter); 
        return findIterable.iterator();
    }
    public static void main(String args[]) {
        TestCollection tc = new TestCollection(); 
        Iterator iterator = tc.find( and(
            eq("version", "v0.1"), 
            eq("module","BirthdayCount"), 
            eq("class","BirthdayCalculation"),
            eq("method","calculator")
            ));
        iterator = tc.find(); 
        while( iterator.hasNext() ) {
            System.out.println(iterator.next()); 
        }
    }
}