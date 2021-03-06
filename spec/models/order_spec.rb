require 'rails_helper'

describe Order, type: :model do
  describe "validations" do
    it { should validate_presence_of :name }
    it { should validate_presence_of :address }
    it { should validate_presence_of :city }
    it { should validate_presence_of :state }
    it { should validate_presence_of :zip }
  end

  describe "relationships" do
    it {should have_many :item_orders}
    it {should have_many(:items).through(:item_orders)}
  end

  describe 'instance methods' do
    before :each do
      @meg = Merchant.create(name: "Meg's Bike Shop", address: '123 Bike Rd.', city: 'Denver', state: 'CO', zip: 80203)
      @brian = Merchant.create(name: "Brian's Dog Shop", address: '125 Doggo St.', city: 'Denver', state: 'CO', zip: 80210)

      @tire = @meg.items.create(name: "Gatorskins", description: "They'll never pop!", price: 100, image: "https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588", inventory: 12)
      @pull_toy = @brian.items.create(name: "Pull Toy", description: "Great pull toy!", price: 10, image: "http://lovencaretoys.com/image/cache/dog/tug-toy-dog-pull-9010_2-800x800.jpg", inventory: 32)

      @fred = User.create(name: "Fred Savage",
                   address: "666 Devil Ave",
                   city: "Mesatown",
                   state: "AZ",
                   zip: '80085',
                   email: "rando@gmail.com",
                   password: "test",
                   role: 0)
      @order_1 = @fred.orders.create!(name: 'Meg', address: '123 Stang Ave', city: 'Hershey', state: 'PA', zip: 17033, status: "pending")

      @order_1.item_orders.create!(item: @tire, price: @tire.price, quantity: 5, status: 'fulfilled')
      @item_order_1 = @order_1.item_orders.create!(item: @pull_toy, price: @pull_toy.price, quantity: 3, status: 'fulfilled')
    end

    it 'grandtotal' do
      expect(@order_1.grandtotal).to eq(530)
    end

    it "item quantity" do
      expect(@order_1.quantity).to eq(2)
    end

    it 'grandtotal by merchant' do
      expect(@order_1.grandtotal_by_merchant(@meg.id)).to eq(500)
    end

    it "item quantity by merchant" do
      expect(@order_1.quantity_by_merchant(@meg.id)).to eq(5)
    end

    it "cancel order" do
      @order_1.cancel_order

      expect(@order_1.item_orders.first.item.inventory).to eq(17)
      expect(@order_1.item_orders.first.status).to eq('unfulfilled')
      expect(@order_1.item_orders.last.status).to eq('unfulfilled')
      expect(@order_1.status).to eq('cancelled')
    end

    it "#all_items_fullfilled" do
      expect(@order_1.status).to eq("pending")
      @order_1.all_items_fullfilled
      expect(@order_1.status).to eq("packaged")
    end

    it "merchant_items returns item_orders for specific merchent" do
      expect(@order_1.merchant_items(@brian.id)).to eq([@item_order_1])
    end
  end
end
