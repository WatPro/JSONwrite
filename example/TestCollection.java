import com.mongodb.MongoClient;
import com.mongodb.client.MongoDatabase;
import com.mongodb.client.MongoCollection;
import com.mongodb.client.FindIterable;

import org.bson.Document;
import org.bson.conversions.Bson; 
import java.lang.Iterable; 

//import static com.mongodb.client.model.Filters.*;
import static com.mongodb.client.model.Filters.and;
import static com.mongodb.client.model.Filters.eq;

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
    public Iterable<Document> find() {
        FindIterable<Document> findIterable = collection.find(); 
        return findIterable;
    }
    public Iterable<Document> find(Bson filter) {
        FindIterable<Document> findIterable = collection.find(filter); 
        return findIterable;
    }
    public static void main(String args[]) {
        TestCollection tc = new TestCollection(); 
        Iterable<Document> iterable = tc.find(); 
        for( Document document : iterable ) {
            System.out.println( document ); 
        }
    }
}