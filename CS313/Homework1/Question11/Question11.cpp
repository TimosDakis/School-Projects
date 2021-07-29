#include <iostream>


class Restaurant {
protected:
    //stores something Restaurant serves
    std::string drink, appetizer, meal, dessert;

public:
    //constructor
    Restaurant(std::string drink, std::string appetizer, std::string meal, std::string dessert) : drink(drink), appetizer(appetizer), meal(meal), dessert(dessert) {}

    //setters
    void setDrink(std::string drink) {
        this->drink = drink;
    }

    void setAppetizer(std::string appetizer) {
        this->appetizer = appetizer;
    }

    void setMeal(std::string meal) {
        this->meal = meal;
    }

    void setDessert(std::string dessert) {
        this->dessert = dessert;
    }

    //getters
    std::string getDrink() { return drink;  }
    std::string getAppetizer() { return appetizer; }
    std::string getMeal() { return meal; }
    std::string getDessert() { return dessert; }   

    virtual void Menu() = 0;

};

class Greek_Restaurant : public Restaurant {

public:

    //constructor
    Greek_Restaurant(std::string drink, std::string appetizer, std::string meal, std::string dessert) : Restaurant(drink, appetizer, meal, dessert) {}

    //Menu function: prints out variables
    void Menu() override {
        std::cout << "GREEK RESTAURANT MENU:\nDrink: " << drink << "\nAppetizer: " << appetizer << "\nMeal: " << meal << "\nDessert: " << dessert << std::endl;
    }

};

class American_Restaurant : public Restaurant {

public:

    //constructor
    American_Restaurant(std::string drink, std::string appetizer, std::string meal, std::string dessert) : Restaurant(drink, appetizer, meal, dessert) {}

    //Menu function: prints out variables
    void Menu() override {
        std::cout << "AMERICAN RESTAURANT MENU:\nDrink: " << drink << "\nAppetizer: " << appetizer << "\nMeal: " << meal << "\nDessert: " << dessert << std::endl;
    }

};

class Italian_Restaurant : public Restaurant {

public:

    //constructor
    Italian_Restaurant(std::string drink, std::string appetizer, std::string meal, std::string dessert) : Restaurant(drink, appetizer, meal, dessert) {}

    //Menu function: prints out variables
    void Menu() override {
        std::cout << "ITALIAN RESTAURANT MENU:\nDrink: " << drink << "\nAppetizer: " << appetizer << "\nMeal: " << meal << "\nDessert: " << dessert << std::endl;
    }

};



template <class T>
class Robot_Reader {
private:
    T m_restaurant;

public:
    Robot_Reader(T restaurant) : m_restaurant(restaurant) {}

    void printMenu() {
        m_restaurant.Menu();
    }
};


int main()
{

    //creating the variables
    Greek_Restaurant greek = Greek_Restaurant("Water", "Salad", "Gyro", "Baklava");
    American_Restaurant american = American_Restaurant("Cola", "Fries", "Burger", "Chocolate Sundae");
    Italian_Restaurant italian = Italian_Restaurant("Coffee", "Soup", "Pizza", "Tiramisu");

    //creating the robot readers
    Robot_Reader<Greek_Restaurant> greekReader(greek);
    Robot_Reader<American_Restaurant> americanReader(american);
    Robot_Reader<Italian_Restaurant> italianReader(italian);

    //printing the menus
    greekReader.printMenu();
    std::cout << std::endl;
    americanReader.printMenu();
    std::cout << std::endl;
    italianReader.printMenu();
    std::cout << std::endl;


}