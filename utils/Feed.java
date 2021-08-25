import java.io.LineNumberReader;
import java.io.FileReader;
import java.lang.Math;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;

import kx.c;

public class Feed{
  private static final Logger LOGGER = Logger.getLogger(Feed.class.getName());
  private static final String QFUNC = ".u.upd";
  private static final String TABLENAME = "trades";

  static c.Timespan strToTimespan(String time) {
    long nano = Long.parseLong(time.substring(11));
    nano += Long.parseLong(time.substring(8, 10)) * Math.pow(10, 9);
    nano += Long.parseLong(time.substring(5, 7)) * Math.pow(10, 9) * 60;
    nano += Long.parseLong(time.substring(2, 4)) * Math.pow(10, 9) * 60 * 60;
    return new c.Timespan(nano);
  }

  /**
   * @param kconn Connection that will be sent the inserts
   * @throws java.io.IOException when issue with KDB+ comms
   * @throws c.KException if request evaluation resulted in an error
   */
  static void bulkInsertCSV(c kconn, String fname) throws java.io.IOException, c.KException{
    // Allocate one array per column
    List<c.Timespan> time = new ArrayList<c.Timespan>();
    List<String> sym = new ArrayList<String>();
    List<Double> price = new ArrayList<Double>();
    List<Long> size = new ArrayList<Long>();
    
    LineNumberReader reader = new LineNumberReader(new FileReader(fname));
    
    String line = reader.readLine();
    System.out.println("Columns are: " + line);
    while ((line = reader.readLine()) != null) {
      System.out.println(line);
      String[] rowStr = line.split(",");
      time.add(strToTimespan(rowStr[0]));
      sym.add(rowStr[1]);
      price.add(Double.parseDouble(rowStr[2]));
      size.add(Long.parseLong(rowStr[3]));
    }
    int row_count = reader.getLineNumber();
    reader.close();
    System.out.println("Read in " + row_count + " rows");

    LOGGER.log(Level.INFO,"Populating 'trades' with a " + row_count + " rows bulk insert...");
    kconn.ks(QFUNC,TABLENAME,new Object[]{
      time.toArray(),
      sym.toArray(),
      price.toArray(),
      size.toArray()
    });
    kconn.k(""); // sync chase ensures the remote has processed all msgs
  }

  public static void main(String[] args){
    c c=null;
    String host = "localhost";
    int port = 5010;
    if (args.length > 1) {
      host = args[1];
      port = Integer.parseInt(args[2]);
    };
     
    try{
      c=new c(host,port);
      bulkInsertCSV(c, args[0]);
    }
    catch(Exception e){
      LOGGER.log(Level.SEVERE,e.toString());
    }finally{
      if(c!=null)
        try{c.close();}catch(java.io.IOException e){
          // ingnore exception
        }
    }
  }
}
