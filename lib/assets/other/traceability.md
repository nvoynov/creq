basen on BABOK?

# Requirements attributes

While eliciting requirements, business analysts elicit requirement attributes. Information such as `the requirement’s source`, `priority`, and `complexity` aid in managing each requirement throughout the life cycle.

Some attributes change as the business analyst uncovers more information and conducts further analysis. An attribute may change even though the requirement does not.

# Traceability

There are several types of relationships that the business analyst considers when defining the traceability approach:

* __Derive__: relationship between two requirements, used when a requirement is derived from another requirement. This type of relationship is appropriate to link the requirements on different levels of abstraction. For example, a solution requirement derived from a business or a stakeholder requirement.
* __Depends__: relationship between two requirements, used when a requirement depends on another requirement. Types of dependency relationships include:
  * __Necessity__: when it only makes sense to implement a particular requirement if a related requirement is also implemented.
  * __Effort__: when a requirement is easier to implement if a related requirement is also implemented.
* __Satisfy__: relationship between an implementation element and the requirements it is satisfying. For example, the relationship between a functional requirement and a solution component that is implementing it.
* __Validate__: relationship between a requirement and a test case or other element that can determine whether a solution fulfills the requirement.
