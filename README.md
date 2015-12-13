# RubyResult

Provides a very simple set of objects for dealing with return values in a more structured and consistent way.

```ruby
include RubyResult

case result = Something.perform(*args)
when Success then do_something
when Failure then do_something_else
end
```

## Installation

```ruby
gem 'ruby_result'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install ruby_result

## Usage

This gem provides two objects, `RubyResult::Success` and `RubyResult::Failure`. Each are initialized with one object, the `value`. The value can be anything, though for consistency I usually return a `Hash`. The gem is intended to help structure the handling of return values.

As an example, consider an ordering system where many things could fail when attempting to place an order. We'd want to wrap creating an order in a method or module but return an object that can represent success or failure and in each case provide some value.


```ruby
module Orders
  include RubyResult

  def create_order(product, order_options:, customer_options:, shipping_address_options:, charge_options:)
    result = nil

    product.with_lock do
      result = Failure(errors: ["Sold out"]) and raise ActiveRecord::Rollback if product.sold_out?

      customer = Customer.find_or_create_by(customer_options)
      result = Failure(customer.errors.full_messages) and raise ActiveRecord::Rollback unless customer.valid?

      address = Address.find_or_create_by(shipping_address_options.merge(product: purchaser))
      result = Failure(address.errors.full_messages) and raise ActiveRecord::Rollback unless address.valid?

      order = Orders::Order.create(order_options)
      result = Failure(order.errors.full_messages) and raise ActiveRecord::Rollback unless order.valid?

      charge = Orders::Charge.create(charge_options.merge(order: order))
      result = Failure(charge.errors.full_messages) and raise ActiveRecord::Rollback unless charge.valid?

      result = Success(product: product, order: order, customer: customer, address: address, charge: charge)
    end

    result
  end
end
```

Then we could call the above and handle the result in an Orders controller.

```ruby
class OrdersController < ApplicationController
  include RubyResult

  def create
    product = load_product(params[:product_id])

    case result = Orders.create_order(product, order_options: order_options, customer_options: customer_options, shipping_address_options: shipping_address_options, charge_options: charge_options)
    when Success
      redirect_to customer_order_path(result.value[:customer], result.value[:order]), notice: "Successfully completed order"
    when Failure
      redirect_to product_path(product), alert: result.value[:errors].join(". ")
    end
  end
end
```

## API

#### RubyResult#Success(value)

Convenience method for constructing a `RubyResult::Success` object.

#### RubyResult#Failure(value)

Convenience method for constructing a `RubyResult::Failure` object.

#### .new(value)

Create a new `Success` or `Failure` object with some arbitrary value.

#### .===(other)

Compare `other` with `self`. If `other` is an instance of `self`, then it is true. Usefull in case statements.

#### #success?

Returns true if `self` is an instance of `RubyResult::Success`.

#### #failure?

Returns true if `self` is an instance of `RubyResult::Failure`.

#### #value

Returns the value provided when constructing an `Success` or `Failure` object.


## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/benjreinhart/ruby_result. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

