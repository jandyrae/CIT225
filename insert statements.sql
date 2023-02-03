
use recipes;

-- insert into contributor
INSERT INTO `recipes`.`contributor`
(`contributor_id`,
`contributor_name`,
`contributor_email`)
VALUES
(1,
'Jandy Kiger',
'jandyrae@gmail.com'),
(2,
'Jaquelle Dodge',
'jaquelledodge@gmail.com'),
(3,
'Marissa Perrett',
'marissa.perrett@gmail.com'),
(4,
'Michelle Higdon',
'princesstigerlilly07@gmail.com'),
(5,
'Jaynann Perrett',
'jaynannperrett@gmail.com');
select * from contributor; -- see if fields look right


-- insert into difficulty
INSERT INTO `recipes`.`difficulty`
(`difficulty_id`,
`difficulty`)
VALUES
(1,
'Expert'),
(2,
'Comfortable'),
(3,
'Beginner'),
(4,
'Children');

-- insert into food_category
INSERT INTO `recipes`.`food_category`
(`food_category_id`,
`food_category_name`)
VALUES
(1,
'Main Dishes'),
(2,
'Salads'),
(3,
'Side Dishes'),
(4,
'Appetizers'),
(5,
'Soups'),
(6,
'Breads'),
(7,
'Holiday'),
(8,
'Non-Foods'),
(9,
'Dips/Dressings/Sauces'),
(10,
'Drinks');

-- instert into rating
INSERT INTO `recipes`.`rating`
(`rating_id`,
`rating`)
VALUES
(1,
'5'),
(2,
'4'),
(3,
'3'),
(4,
'2'),
(5,
'1');

-- insert into how_to
INSERT INTO `recipes`.`how_to`
(`how_to_id`,
`how_to_make`)
VALUES
(1,
'Melt butter/margarine. Stir in soup and sour cream. 
Pour over hashbrowns, mix well. 
Stir in some of the cheese, if too dry add more sour cream. 
Put in baking dish and sprinkle cheese over the top. 
Bake at 350 for 30 or until heated through and cheese is melted.'),
(2,
'Combine dry ingredients, (flour, sugar, salt, yeast).
Add lecithin and hot water to the dry ingredients and check for sticky consistency once all mixed in.
Mix/knead at medium speed for 5 minutes.
Remove from mixer and hand knead to remove any large air pockets.
Shape into loaves or rolls let rise 20 mins and bake at 350 for 18-25 minutes.'),
(3,
'Mush together meat and ingredients with fingers,
Put into loaf pan or similar.
Cook at 350 for 1 hour (remove at 30min to drain grease and add ketchup/BBQ topping).');

-- insert recipe images
INSERT INTO `recipes`.`image`
(`image_id`,
`image_name`,
`image_file`)
VALUES
(1,
'cheesy potatoes',
'deathSpuds.jpg'),
(2,
'homemade bread',
'bread.jpg'),
(3,
'meatloaf',
'meatloaf.jpg');

-- insert into ingredients
INSERT INTO `recipes`.`ingredients`
(`ingredients_id`,
`ingredients`)
VALUES
(1,
'1 lb shredded hashbrowns
1/2 cup butter or margarine
1 cup sour cream
1 can cream of chicken soup
8-16 oz. grated cheese'),
(2,
'10 1/2 cups bread flour
1/2 cup sugar
1 Tbsp salt
3 rounded Tbsp SAF instant yeast
3 quarter-sized drops of liquid lecithin
4 cups hot tap water - not too hot '),
(3,
'2 lbs thawed hamburger
2 eggs
1 cup rolled oats / crushed saltine crackers
garlic salt
3 Tbsp ketchup / BBQ sauce - to top');

-- insert key ingredients to be able to query
INSERT INTO `recipes`.`key_ingredient`
(`key_ingredient_id`,
`key_ingredient_name`)
VALUES
(1,
'flour'),
(2,
'potatoes'),
(3,
'hamburger');

-- insert into meal time
INSERT INTO `recipes`.`meal_time`
(`meal_time_id`,
`meal_time_col`)
VALUES
(1,
'Breakfast'),
(2,
'Lunch'),
(3,
'Dinner'),
(4,
'Any');

-- insert 
INSERT INTO `recipes`.`time_to_make`
(`time_to_make_id`,
`time_amount`)
VALUES
(1,
'1 hour'),
(2,
'45 min'),
(3,
'1 hour 15 min');

-- insert into recipes
INSERT INTO `recipes`.`recipes`
(`recipes_id`,
`recipes_name`,
`recipes_description`,
`rating_id`,
`ingredients_id`,
`how_to_id`,
`difficulty_id`,
`time_to_make_id`,
`meal_time_id`)
VALUES
(1,
'Death Spuds',
'Family favorite cheesy potatoes',
1,
1,
1,
3,
2,
3),
(2,
'Homemade Bread',
'Family favorite bread dough recipe',
1,
2,
2,
2,
1,
4),
(3,
'Meatloaf',
'Family favorite meatloaf',
1,
3,
3,
3,
2,
3);

-- insert into linking table recipes and contributors
INSERT INTO `recipes`.`recipes_has_contributors`
(`recipes_id`,
`contributor_id`)
VALUES
(1,
5),
(2,
1),
(3,
5);

-- insert into linking table recipes and food category
INSERT INTO `recipes`.`recipes_has_food_category`
(`recipes_id`,
`food_category_id`)
VALUES
(1,
3),
(2,
6),
(3,
1);

-- insert into linking table recipes and images
INSERT INTO `recipes`.`recipes_has_image`
(`recipes_id`,
`image_id`)
VALUES
(1,
1),
(2,
2),
(3,
3);

-- insert into linking table recipes and key ingredients
INSERT INTO `recipes`.`recipes_has_key_ingredients`
(`recipes_id`,
`key_ingredient_id`)
VALUES
(1,
1),
(2,
2),
(3,
3);

select * from rating;

select * 
from recipes r
	join recipes_has_contributors rc 
		on r.recipes_id = rc.recipes_id
	join contributor c 
    on c.contributor_id = rc.contributor_id
where contributor_name = 'Jaynann Perrett';


select recipes_name, ingredients, how_to_make 
from recipes r 
	join ingredients i 
		on r.ingredients_id = i.ingredients_id
    join how_to h 
		on r.how_to_id = h.how_to_id
where recipes_id = 1;        


select recipes_name, ingredients, how_to_make 
from recipes r 
	join ingredients i 
		on r.ingredients_id = i.ingredients_id
    join how_to h 
		on r.how_to_id = h.how_to_id
where recipes_name like '%Spud%';      


create view general_vw (Recipe, Rating, Contributor, Category, Difficulty, Time )
as select rec.recipes_name, 
case 
when r.rating = 1 then 'Five Stars'
when r.rating = 2 then 'Four Stars'
when r.rating = 3 then 'Three Stars'
when r.rating = 4 then 'Two Stars'
else 'One Star'
end,
c.contributor_name, fc.food_category_name, d.difficulty, t.time_amount
from recipes rec 
inner join rating r on rec.rating_id = r.rating_id
inner join recipes_has_contributors rc on rec.recipes_id = rc.recipes_id
inner join contributor c on rc.contributor_id = c.contributor_id
inner join recipes_has_food_category rfc on rec.recipes_id = rfc.recipes_id
inner join food_category fc on rfc.food_category_id = fc.food_category_id
inner join difficulty d on rec.difficulty_id = d.difficulty_id
inner join time_to_make t on rec.time_to_make_id = t.time_to_make_id;

select * from general_vw;

DELETE FROM `recipes`.`recipes`
WHERE recipes_id = 4 and recipes_name = 'Rice Pudding';
