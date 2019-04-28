void setup() {
    size(1000,800);
}

void draw() {
    // Mode = 0 | 1 | 2 (small, medium, large)
    int mode = 0;
    int rooms = get_number_of_rooms(mode);
    System.out.println("Room number: "+ rooms);

    //int total_nodes = rooms + (rooms - 1);
    //System.out.println("Total nodes: "+ total_nodes);

    tree_node tree = rec_gen_tree(rooms);
    draw_rooms(0, 1000, 0, 800, tree);
    draw_connectors(tree);
    noLoop();
}

void draw_rooms(int lower_x, int upper_x, int lower_y, int upper_y, tree_node tree) {
    if (tree.is_room) {
        //Draw room, add room coords to tree node
        draw_room(lower_x, lower_y, upper_x, upper_y, tree);
    }
    else {  
        // Draw line, split coords on line and rec call fun with left and right subtree
        String line_direction = horizontal_or_vertical();
        if (line_direction.equals("horizontal")) {
            // Draw horizontal line along x axis, y axis stays the same
            int y_line = lower_y + (upper_y - lower_y)/2;
            tree.set_line_coordinates(lower_x + (upper_x - lower_x)/2 , y_line);
            line(float(lower_x), float(y_line), float(upper_x), float(y_line));
            draw_rooms(lower_x, upper_x, lower_y, y_line, tree.left);
            draw_rooms(lower_x, upper_x, y_line, upper_y, tree.right);
        }
        else {
            // Draw vertical line along y axis, x axis stays the same
            int x_line = lower_x + (upper_x - lower_x)/2;
            tree.set_line_coordinates(lower_y + (upper_y - lower_y)/2 , x_line);
            line(float(x_line), float(lower_y), float(x_line), float(upper_y));
            draw_rooms(lower_x, x_line, lower_y, upper_y, tree.left);
            draw_rooms(x_line, upper_x, lower_y, upper_y, tree.right);
        }
    }
}

void draw_connectors(tree_node tree) {
      if (tree.is_room) {
          //Nothing to be done 
      }
      else {
          float [] tree_line_coords = tree.get_line_coordinates();
          tree_node left_room = get_closest_room(tree.left, tree_line_coords[0], tree_line_coords[1]);
          tree_node right_room = get_closest_room(tree.right, tree_line_coords[0], tree_line_coords[1]);
          draw_corridor(left_room, right_room);
          draw_connectors(tree.left);
          draw_connectors(tree.right);
      }
}

void draw_corridor(tree_node left_room, tree_node right_room) {
    float [] left_room_coords = left_room.get_room_coordinates();
    float [] right_room_coords = right_room.get_room_coordinates();
    float left_x = left_room_coords[0] + (left_room_coords[1]-left_room_coords[0])/2;
    float left_y = left_room_coords[2] + (left_room_coords[3]-left_room_coords[2])/2;
    float right_x = right_room_coords[0] + (right_room_coords[1]-right_room_coords[0])/2;
    float right_y = right_room_coords[2] + (right_room_coords[3]-right_room_coords[2])/2;
    line(left_x, left_y, right_x, right_y);
}

tree_node get_closest_room(tree_node subtree, float x_coord, float y_coord) {
    if (subtree.is_room){
        return subtree;
    }
    else {
        tree_node left_room = get_closest_room(subtree.left, x_coord, y_coord);
        tree_node right_room = get_closest_room(subtree.right, x_coord, y_coord);
        return compare_distance(left_room, right_room, x_coord, y_coord);
    }
}

tree_node compare_distance(tree_node room1, tree_node room2, float x_coord, float y_coord){
    float [] room1_coords = room1.get_room_coordinates();
    float [] room2_coords = room2.get_room_coordinates();
    float room1_distance = get_closest_distance_x(room1_coords, x_coord) + get_closest_distance_y(room1_coords, y_coord);
    float room2_distance = get_closest_distance_x(room2_coords, x_coord) + get_closest_distance_y(room2_coords, y_coord);
    if (room1_distance < room2_distance){
        return room1;
    }
    else {
        return room2; 
    }   
}

float get_closest_distance_x(float [] room_coords, float coordinate){
    float closest_value = 10000;
    for (int x = 0; x<2; x++){
        if (abs(coordinate - room_coords[x]) < closest_value){
            closest_value = abs(coordinate - room_coords[x]);
        }
    }
    return closest_value;
}

float get_closest_distance_y(float [] room_coords, float coordinate){
    float closest_value = 10000;
    for (int x = 2; x<4; x++){
        if (abs(coordinate - room_coords[x]) < closest_value){
            closest_value = abs(coordinate - room_coords[x]);
        }
    }
    return closest_value;
}

void draw_room(int x1, int y1, int x2, int y2, tree_node node) {
    int x_dif = x2 - x1;
    int y_dif = y2 - y1;
    float rect_x1 = random(x1, x1+(x_dif/2));
    float rect_x2 = random(x1+(x_dif/2), x2);
    float rect_y1 = random(y1, y1+(y_dif/2));
    float rect_y2 = random(y1+(y_dif/2), y2);
    node.set_room_coordinates(rect_x1, rect_y1, rect_x2, rect_y2);
    rect(rect_x1, rect_y1, rect_x2-rect_x1, rect_y2-rect_y1);
}

class tree_node {  
   tree_node left;
   tree_node right;
   tree_node parent;
   float [] room_coordinates = new float[4];
   float [] line_coordinates = new float [2];
   boolean is_room;
   
   tree_node(tree_node left_node, tree_node right_node, tree_node parent_node, boolean room){
       left = left_node;
       right = right_node;
       parent = parent_node;
       is_room = room;
   }
   
   void set_room_coordinates(float x1,float y1, float x2, float y2){
       room_coordinates[0] = x1;
       room_coordinates[1] = x2;
       room_coordinates[2] = y1;
       room_coordinates[3] = y2;
   }
   
   float [] get_room_coordinates(){
       return room_coordinates; 
   }
   
   void set_line_coordinates(float x1,float y1){
       line_coordinates[0] = x1;
       line_coordinates[1] = y1;
   }
   
   float [] get_line_coordinates(){
       return line_coordinates; 
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
