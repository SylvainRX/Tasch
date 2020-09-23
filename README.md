# Tasch

Instructions: 
 - [/Demo and Instruction/Instructions.pdf](https://github.com/SylvainRX/Tasch/blob/master/Demo%20and%20Instruction/Instructions.pdf)

My results: 
 - [/Demo and Instruction/Demo/Video.mov](https://github.com/SylvainRX/Tasch/blob/master/Demo%20and%20Instruction/Demo/Video.mov)
 - [/Demo and Instruction/Demo/Images](https://github.com/SylvainRX/Tasch/tree/master/Demo%20and%20Instruction/Demo/Images)

This project goal is to demonstrate the usage of Clean Architecture and VIPER UI in an iOS app as well as Test Drive Development.<br>
The allotted time for this project was about 20 hours. Because of this, it isn't perfect and the whole project wasn't done in TDD

## Clean Architecture

Tasch is based on Clean Architecture, theorized by Robert C. Martin.<br>
Clean Architecture divides the software into four layers in order to achieve a separation of concerns, testability, and independence from frameworks or databases.

The lower a layer is, the more dependent it is on the hardware input and outputs.
A level must not know anything about a lower level one. A level do know about the levels above itself.<br>

### The Layers
From the highest level to the lowest, Clean Architecture layers are:

#### - Entities 
The highest level layer, meaning it does not depend on anything. <br>
Entities (ex: Tash.DetailedProduct) are data structures representing the enterprise data.<br>

#### - Use Cases
Use Cases represent the application specific business rules which depend on entities.<br>
For instance, Tash.DetailedProductUseCase allows to retrieve a product, save in in the wish list or remove it from it.

#### - Interface Adapters
They convert the data from the higher levels to their own level (for instance a model to be injected in a view), or convert the data from an external source to a higher level Entity. <br>
As such, the Presenters in the app convert data received from the Use Cases to a model.<br>
TashEngine.TashDataLayer, which implements the higher level protocol Tash.DataLayer, converts data from an external source (a json file in our case) to the higher level Entity.

#### - Frameworks and Drivers
The lowest level, meaning that it is the closest layer to the hardware, user interface, databases, network access, etc.<br>
The ViewControllers are part of this layer as they are directly dependent on UIKit.<br>
TashDataLayer's fake data loading should have been done in this layer. Or if the data was accessed through a network, here should be implemented network layer, conforming to a protocol defined on the higher level, and injected in TashDataLayer.

### Communication between layers
The layers need to communicate between each other. But as mentioned earlier, a higher level layer cannot depend on a lower one.<br>
In order to achieve this back and forth communication, we use the Dependency Inversion Principle. For a higher level module to communicate to a lower one, it defines a protocol to which the lower module will conform, in order to be injected as a dependance into the higher level Module.
Example: Tash.DetailedProductUseCase has a variable named observer of the protocol type Tash.DetailedProductUseCaseObserver. DetailedProductPresenter implements this protocol and then can be injected in the Use Case as its observer, without the use case knowing about this Presenter.

### Why Clean Architecture?

#### - Independent from the frameworks used, ex: Independent from the UI framework
The presenters and UI models are fully indepentant from UIKit and so the app could use any other framework to display the data, if such a change is needed. For instance AppKit, SwiftUI, and more.

#### - Independent from the database. 
The Use Cases access data through a protocol (Tash.DataLayer) thus is independent from its implementation. 
The protocol Tash.DataLayer could be implemented using a local storage, an access to a database from server, ...

#### - Testable: 
The app's business rules (Use Cases) are independent from any external elements (high level) beside entities. Which allows them to be tested in isolation from the app operations.
The presenter's outputs and inputs are independent from UIKit (lowest level) and so can be tested without any dependency but the higher level ones (Use Case), which can be mocked.<br>
We need this independence from UIKit to have a testable presenter because, it won't depend on the life cycle of a UIViewController's<br>
We do not test the view: the view must be dumb, which means it does not do any operations, it only shows data that are already formatted by the presenter. Another reason for not testing the view is that it is the most volatile components of the app and will change a lot during the development process, making tests obsolete quickly.

### Also:
Clean Architecture is great in term of maintainability as it forces the developper to clearly separate every concerns in multiple smaller modules, then avoiding spaghetti code and improving readability.<br>
Its modular structure allows for multiple developers to work on the same feature.<br>

A market app like Tasch will eventually grow and will require more work force. So as a long term project, this architecture is suited for it.

## Clean VIPER
VIPER is a UI design pattern, it is an acronym which stands for View Interactor Presenter Entity Router. Those are the four components of VIPER that we will describe in this section. We will also see here that VIPER lends itself well for a Clean Architecture design. 

#### View
The View is the user interface, in our case UIViewControllers and UIViews.<br>
It does not make any transformation of data. Its only responsibilities are to display the model given by the presenter and transfer the user inputs to the presenter.<br>
In order for the View not to make any data transformations, its model must be ready to displayed. For instance if a number must be shown in the View, then it should already be formatted as a String in the view model<br>

The view is part of the lowest CA layer, Frameworks and Drivers, the one that is the closest to the user inputs.

#### Interactor
The Interactor contains the rules of a single Use Case. Following those rules, it gathers Entities to be sent to the presenter, and it reacts the the Presenter inputs.

The Interactor does precisely what a CA Use Case does. In Tash, VIPER's Interactor are suffixed by "UseCase" (ex: DetailedProductUseCase ).

#### Presenter
The Presenter transforms the Entities from the Interactor into the View's model and sends it to the View. It also receives user inputs from the view<br>
It contains the view's logic, which means how the view should behave in response to the Interactor states updates. Which comprises communicating with the Router for some Interactor states or View inputs<br>

Presenters are part of the Interface Adapters level.

#### Entity
Entities are the data object gathered by the Interactor and sent to the Presenter. They are at the Entity level.

#### Router
The Router responds to the Presenters inputs to move from the current View to another. It implies that it is responsible for creating the next view to be presented.<br>
The presenter may also send data to the Router in order for it to build a View.

In our case, the Routers are part of the lowest layer, Frameworks and Drivers, as they directly deal with the instantiations of UIViewControllers.

### Construction of a VIPER UI
As mentioned above, the Router is responsible for the instantiation of UIViewController.s. The UIAppDelegate, or UISceneDelegate in iOS 13, belong to the lowest level. As such , they will also have the role to instantiate the first UIViewController, in our case, the HomeViewController.

In Tash a ViewController will then instantiate the whole VIPER 'stack' as it is a component of the lower level and knows all the levels above itself.<br>
So it will instantiate its Presenter, Router, and UseCase.<br>
Then to hold all those modules in memory, the ViewController will have a reference on the Presenter, the Presenter will have references on its Router and UseCase.<br>
Following the Dependency Inversion Principle, the UseCase will have a weak reference on an Observer implemented by the Presenter, and the Presenter will have a weak reference on a View, implemented by the ViewController. The weak references here allows to avoid retain cycles between the components.


## Dependency Injection

### Resolver
As described on their GitHub page, Resolver is Pod for Dependency Injection and a Service Locator.<br>
Tash uses Resolver to hold the Localization, the ColorTheme and, Tash.DataLayer. For instance, when a UIViewController instantiate its VIPER 'stack', it will use it lo locate Tash.DataLayer and inject it into its UseCase.<br>
Using this rather than singletons allows for testability. 

https://github.com/hmlongco/Resolver
https://cocoapods.org/pods/Resolver

## Unit testing and TDD

Pros:
 - Makes maintaining and refactoring a project quicker on the long run. Reduces the fear of change.
 - Less bugs and regressions, which implies less supports.
 - Forces the developper to modularize their code
 - 100% test coverage (or almost, as we generally don't test the view)
 - Documents the code

Cons:
- A lot of code to write. Test code are often between 2 to 3 times the number of lines of the production code.
- Generally slower than coding production code straightaway
- Ideally, the whole dev team should do TDD on modules that were started using TDD. 

I would have liked to develop Tash only using TDD, but it was not doable within the time allotted for this project.<br>
To provide an example, I did it for the Localization of currencies, the ProductCataloguePresenter, the ProductCatalogueUseCase, and the WishListUseCase.  

## Views

### Views Arrangement

#### Home
Files: /TaschEngine/Home
HomeViewController represents the screen 1 and 1-4. It does not contain any logic and its only role is to instantiate its child ViewControllers and display their views : ProductCatalogueViewController and CartViewController.

#### Product Catalogue
Low level files: /TaschEngine/ProductCatalogue<br>
High level files: /Tasch/ProductCatalogue<br>
ProductCatalogueViewController represents the list of products from the catalogue. Each product is displayed in a ProductCatalogueCell <br>
Touching a product opens the details of this product in ProductDetailViewController.

#### Cart 
Low level files: /TaschEngine/Cart<br>
High level files: /Tasch/Cart<br>
CartViewController instantiate its child WishListViewController and displays its view, the cumulated cost of the products in the wish list, and the button to check out.

#### Wish List
Low level files: /TaschEngine/WishList<br>
High level files: /Tasch/WishList<br>
WishListViewController displays the content of the user's wish list, with each item displayed in a WishListItemView.<br>
Touching an item opens its details in ProductDetailViewController.

#### Product Detail
Low level files: /TaschEngine/ProductDetail<br>
High level files: /Tasch/ProductDetail<br>
ProductDetailViewController represents the screen 1-1 and 1-2.<br>
ProductDetailViewController displays the informations of the product and shows an "add to wish list" button if the product is not in the wish lit, or else a "remove from wish list" button.<br>
This ViewController contain a DetailedProductRatingView which allows the user to rate the product.

### Full Code

Tasch does not use Storyboard for its ViewControllers as they impose the use of UIStoryboardSegues. Using Segues would break the VIPER design and breaks the Single Responsibility Principle by giving the routing responsibility to the ViewControllers.<br>
Moreover, injecting information from a ViewController to another, using prepareForSegue, is not as clean as using a Router.

Tash only uses code to create its views. I took this decision because it is more performant to be displayed. It also makes the code easier to review, especially un code review tools like GitLab's. And I also simply wanted to try the little challenge to make a project with views only made of code!

## Error and Loading UI Testing

If you want to test the error handling, in /TaschEngine/_Shared/TaschDataLayer.swift there are several variables that can be set to true to make their corresponding data layer call fail once. isProductCatalogueFakeFailing, for instance.<br>
In the same file, you can modify fakeResponseTime in order to display the loading views for a longer time, or not at all.

## Possible Improvements

The routers in the app are very rudimentary and could possibly be replaced by a routing service.<br>
The UX could be improved, the loading views are a bit strange and the error displays too.<br>
Maybe trying to check out with an out of stock item should promt an error message<br> 
And more.
