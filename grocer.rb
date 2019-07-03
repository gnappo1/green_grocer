require 'pry'

def consolidate_cart(cart)
  final_hash = {}
  cart.each do |element_hash|
    key = element_hash.keys[0]
    if final_hash.has_key?(key)
      element_hash[key][:count] += 1
    else 
      element_hash[key][:count] = 1
      final_hash[key] = element_hash.values[0]
    end
  end
  final_hash
end

def apply_coupons(cart, coupons)
  coupons.each do |coupon|
    item = coupon.values_at(:item)[0]
    if cart.has_key?(item) && !cart.has_key?("#{item} W/COUPON") && cart[item][:count] >= coupon[:num]
      cart["#{item} W/COUPON"] = {price: coupon[:cost]/coupon[:num], clearance: cart[item][:clearance], count: coupon[:num]}
      cart[item][:count] -= coupon[:num]
    elsif cart.has_key?("#{item} W/COUPON") && cart[item][:count] >= coupon[:num]
      cart["#{item} W/COUPON"][:count] += coupon[:num]
      cart[item][:count] -= coupon[:num]
    end
  end
  cart
end

def apply_clearance(cart)
  cart.each do |product_name, values|
    values[:price] -= values[:price] * 0.2 if values[:clearance]
  end
  cart
end

def checkout(cart, coupons)
  hash_cart = consolidate_cart(cart)
  applied_coupons = apply_coupons(hash_cart, coupons)
  applied_discount = apply_clearance(applied_coupons)
  total = applied_discount.reduce(0) { |acc, (k, v)| acc += v[:price] * v[:count]}
  total > 100 ? total * 0.9 : total
end
