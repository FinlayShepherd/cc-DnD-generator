void setup() {
    size(1000,800);
}

void draw() {
    // Mode = 0 | 1 | 2 (small, medium, large)
    int mode = 1;
    int rooms = get_number_of_rooms(mode);
    System.out.println("Room number: "+ rooms);

    //int total_nodes = rooms + (rooms - 1);
    //System.out.println("Total nodes: "+ total_nodes);

    tree_node tree = rec_gen_tree(rooms);
    draw_lines(0, 1000, 0, 800, tree);
    noLoop();
}

void draw_lines(int lower_x, int upper_x, int lower_y, int upper_y, tree_node tree) {
    if (tree.is_room) {
        //Do nothing
        draw_room(lower_x, lower_y, upper_x, upper_y);
    }
    else {  
        // Draw line, split coords on line and rec call fun with left and right subtree
        String line_direction = horizontal_or_vertical();
        if (line_direction.equals("horizontal")) {
            // Draw horizontal line along x axis, y axis stays the same
            int y_line = lower_y + (upper_y - lower_y)/2;
            line(float(lower_x), float(y_line), float(upper_x), float(y_line));
            draw_lines(lower_x, upper_x, lower_y, y_line, tree.left);
            draw_lines(lower_x, upper_x, y_line, upper_y, tree.right);
        }
        else {
            // Draw vertical line along y axis, x axis stays the same
            int x_line = lower_x + (upper_x - lower_x)/2;
            line(float(x_line), float(lower_y), float(x_line), float(upper_y));
            draw_lines(lower_x, x_line, lower_y, upper_y, tree.left);
            draw_lines(x_line, upper_x, lower_y, upper_y, tree.right);
        }
    }
}

void draw_room(int x1, int y1, int x2, int y2) {
    int x_dif = x2 - x1;
    int y_dif = y2 - y1;
    float rect_x1 = random(x1, x1+(x_dif/2));
    float rect_x2 = random(x1+(x_dif/2), x2);
    float rect_y1 = random(y1, y1+(y_dif/2));
    float rect_y2 = random(y1+(y_dif/2), y2);
    rect(rect_x1, rect_y1, rect_x2-rect_x1, rect_y2-rect_y1);
}

class tree_node {  
   tree_node left;
   tree_node right;
   tree_node parent;
   boolean is_room;
   
   tree_node(tree_node left_node, tree_node right_node, tree_node parent_node, boolean room){
       left = left_node;
       right = right_node;
       parent = parent_node;
       is_room = room;
   }
}

int get_number_of_rooms(int size) {
   if (size == 0) {
       return 3;
   }
   else if (size == 1) {
       return 6;
   }
   else {
       return 12; 
   }
}

int minimum_tree_depth(int leaf_count) {
    float x = log2(leaf_count);
    return ceil(x);
}

float log2(int x) {
    return log(x) / log(2); 
}

String horizontal_or_vertical() {
    int x = int(random(1,3));
    if (x == 1) {
        return "vertical";
    }
    else {
        return "horizontal";  
    }
}

tree_node rec_gen_tree(int size) {
    // Random is not inclusive of upper bound
    if (size == 1) {
        System.out.println("Adding leaf node");
        return new tree_node(null, null, null, true);
    }
    else {
        //size--;
        int left = int(random(1, size));
        int right = size - left;
        System.out.println("Adding internal node with left subtree of size: "+ left + " and right of size: " + right);
        return new tree_node(rec_gen_tree(left), rec_gen_tree(right), null, false);
    }    
}
