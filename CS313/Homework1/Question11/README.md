# Problem (Question 11):
- Create a Restaurant superclass, and 3 child classes which are specific types Restaurants, then create a templated robot which reads the menu of these

# Design Overview and Approach:
- I took a very basic approach to this, I set up the Restaurant superclass to have string variables which hold the data about the drink, meal, appetizer, and dessert the menu will contain
    - Then for each of these, set up a getter and setter
- Then I set up Greek, American, and Italian Restaurants to inherit the main Restaurant class, which contains a constructor to call the super class Restaurant to set the variables
- Then overrode the menu function from the super class to print out the menu items for each specific restaurant
- Set up templated reader class that takes in any type of restaurant and executes its menu read function
