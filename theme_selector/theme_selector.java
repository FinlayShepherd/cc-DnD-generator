import java.util.ArrayList;
import java.util.HashMap;
import java.io.BufferedReader;
import java.io.FileReader;



public class theme_selector {

    static ArrayList<String> beast_theme = read_file("Synonyms/Beast.txt");
    static ArrayList<String> bandit_theme = read_file("Synonyms/Bandit.txt");
    static ArrayList<String> dragon_theme = read_file("Synonyms/Dragon.txt");
    static ArrayList<String> enviromental_theme = read_file("Synonyms/Enviromental.txt");
    static ArrayList<String> military_theme = read_file("Synonyms/Military.txt");
    static ArrayList<String> pirate_theme = read_file("Synonyms/Pirate.txt");
    static ArrayList<String> religion_theme = read_file("Synonyms/Religion.txt");
    static ArrayList<String> undead_theme = read_file("Synonyms/Undead.txt");
    static HashMap<String, Integer> theme_weight = new HashMap<String, Integer>();

    static wordnet net = new wordnet();

    public static void main (String [] args) {
    //     ArrayList<String> beast_theme = read_file("Synonyms/Beast.txt");
    //     ArrayList<String> bandit_theme = read_file("Synonyms/Bandit.txt");
    //     ArrayList<String> dragon_theme = read_file("Synonyms/Dragon.txt");
    //     ArrayList<String> enviromental_theme = read_file("Synonyms/Enviromental.txt");
    //     ArrayList<String> military_theme = read_file("Synonyms/Military.txt");
    //     ArrayList<String> pirate_theme = read_file("Synonyms/Pirate.txt");
    //     ArrayList<String> religion_theme = read_file("Synonyms/Religion.txt");
    //     ArrayList<String> undead_theme = read_file("Synonyms/Undead.txt");
        initialise_map();
        read_headline("clean car target needs to be sooner");
        System.out.println("Final result: "+theme_weight);
    }

    private static void read_headline(String headline) {
        String [] headline_words = headline.split(" ");
        for (String w: headline_words) {
            check_word(w);
            System.out.println("Checking word: "+w+", result: "+theme_weight);
            ArrayList<String> synonyms = net.get_synonyms(w);
            rec_check_synonyms(synonyms, 1);
        }
    }

    private static void rec_check_synonyms(ArrayList<String> synonyms, int depth){
        if (depth == 2) {
            for (String w: synonyms) {
                check_word(w);
                // System.out.println(depth);
            }
            //end
        }
        else {
            for (String w: synonyms) {
                check_word(w);
                // System.out.println(depth);
                // System.out.println("Based on word: "+w+ ", I have decided on the themes: "+theme_weight);
                ArrayList<String> s = net.get_synonyms(w);
                rec_check_synonyms(s, depth+1);
            }
        }
    }


    private static void check_word(String word){
        if (beast_theme.contains(word)) {
            int x = theme_weight.get("Beast");
            theme_weight.put("Beast", x+1);
        }
        if (bandit_theme.contains(word)) {
            int x = theme_weight.get("Bandit");
            theme_weight.put("Bandit", x+1);
        }
        if (dragon_theme.contains(word)) {
            int x = theme_weight.get("Dragon");
            theme_weight.put("Dragon", x+1);
        }
        if (enviromental_theme.contains(word)) {
            int x = theme_weight.get("Enviromental");
            theme_weight.put("Enviromental", x+1);
        }
        if (military_theme.contains(word)) {
            int x = theme_weight.get("Military");
            theme_weight.put("Military", x+1);
        }
        if (pirate_theme.contains(word)) {
            int x = theme_weight.get("Pirate");
            theme_weight.put("Pirate", x+1);
        }
        if (religion_theme.contains(word)) {
            int x = theme_weight.get("Religion");
            theme_weight.put("Religion", x+1);
        }
        if (undead_theme.contains(word)) {
            int x = theme_weight.get("Undead");
            theme_weight.put("Undead", x+1);            
        }
    }

    private static void initialise_map() {
        theme_weight.put("Beast", 0);
        theme_weight.put("Bandit", 0);
        theme_weight.put("Dragon", 0);
        theme_weight.put("Enviromental", 0);
        theme_weight.put("Military", 0);
        theme_weight.put("Pirate", 0);
        theme_weight.put("Religion", 0);
        theme_weight.put("Undead", 0);
    }

    private static ArrayList<String> read_file(String filename) {
        ArrayList<String> words = new ArrayList<String>();
        try {
            BufferedReader file_reader = new BufferedReader(new FileReader(filename));

            String line = null;

            while((line = file_reader.readLine()) != null) {
                words.add(line);
            }
            file_reader.close();

            // System.out.println(words);
            return words;
        } catch (Exception e) {
            System.out.println("Error reading: "+filename);
            return words;
        }
    }
}