import java.io.BufferedReader;
import java.io.DataOutputStream;
import java.io.InputStreamReader;

import java.util.ArrayList;


public class wordnet
{
    public static void main(String [] args){
        // ArrayList<String> result = get_synonyms("pain");
        // System.out.println(result);
    }

    public static ArrayList<String> get_synonyms (String word) {
        ArrayList<String> synonyms = new ArrayList<String>();

        try {
            Runtime rt = Runtime.getRuntime();
            Process pr = rt.exec("wn "+word+" -synsn -synsa -synsv -synsr");
            // -synsv -synsr
            BufferedReader input = new BufferedReader(new InputStreamReader(pr.getInputStream()));

            String line=null;

            while((line=input.readLine()) != null) {
                // System.out.println(line);
                if (line.contains("Sense"))
                {
                    String info_line = input.readLine();
                    String [] some_synonyms = info_line.split(", ");
                    for (String s : some_synonyms) {
                        // System.out.println(s);
                        if (s.equals(word)) {
                            //Do not add too list because we just end up with the same results
                        }
                        else {
                            synonyms.add(s);
                        }
                    }
                }
            }
            return synonyms;
            // int exitVal = pr.waitFor();
            // System.out.println("Exited with error code "+exitVal);

        } catch(Exception e) {
            System.out.println(e.toString());
            e.printStackTrace();
            return synonyms;
        }
    }
}

