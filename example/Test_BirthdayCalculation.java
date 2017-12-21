 
import static org.junit.Assert.assertEquals;
import java.util.Calendar; 
import java.util.Date;
import java.util.ArrayList;
import java.util.Collection;
import java.lang.Iterable; 

import org.junit.Test;
import org.junit.runner.RunWith;
import org.junit.runners.Parameterized; 
import org.junit.runners.Parameterized.Parameters; 
import static org.mockito.Mockito.spy; 
import static org.mockito.Mockito.when; 
import org.bson.Document; 
import org.bson.conversions.Bson;
import static com.mongodb.client.model.Filters.and;
import static com.mongodb.client.model.Filters.eq;

@RunWith(Parameterized.class)
public class Test_BirthdayCalculation {
    @Parameters 
    public static Collection<Object[]> data(){
        ArrayList<Object[]> list = new ArrayList<Object[]>();
        Iterable<Document> iterable = new TestCollection().find( and(
            eq("version", "v0.1"), 
            eq("module","BirthdayCount"), 
            eq("class","BirthdayCalculation"),
            eq("method","calculator")
            ));
        for( Document document : iterable ) { 
            Document premise  = (Document) document.get("premise");
            Document input    = (Document) document.get("input");
            Document expect   = (Document) document.get("expect");
            list.add(new Object[]{
                premise.get("today_year"),
                premise.get("today_month"),
                premise.get("today_day"), 
                input.get("DOB_month"),
                input.get("DOB_day"),
                expect.get("answer")
            });
        }
        return list;
    }
    
    private Calendar today;
    
    private int DOB_month;
    
    private int DOB_day;
    
    private int expectedAns; 
    
    public Test_BirthdayCalculation( int now_year, int now_month, int now_day, int dob_month, int dob_day, int expect_ans ) {
        today = Calendar.getInstance(); 
        today.set(now_year,now_month-1,now_day);  
        
        DOB_month = dob_month; 
        DOB_day = dob_day;
        
        expectedAns = expect_ans; 
    }
    
    @Test
    public void calculator() {
        try {
            BirthdayCalculation BC_bc = spy(new BirthdayCalculation());  
            when(BC_bc.getToday()).thenReturn(today);
            int ans = BC_bc.calculator(DOB_month,DOB_day);
            assertEquals(expectedAns,ans); 
        } catch (AssertionError e) {
            throw e; 
        }
    }
}

