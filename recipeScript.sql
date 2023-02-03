use recipe;

INSERT INTO `recipe`.`recipe`
(`recipe_id`,
`rating_id`,
`key_ingredient_id`,
`difficulty_id`,
`time_to_make_id`,
`recipe_name`,
`ingredients_id`,
`recipe_image_id`)
VALUES
(1,
5,
<{key_ingredient_id: }>,
<{difficulty_id: }>,
<{time_to_make_id: }>,
<{recipe_name: }>,
<{ingredients_id: }>,
<{recipe_image_id: }>);
