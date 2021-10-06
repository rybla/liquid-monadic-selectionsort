module Refined.Data.ListOld where

-- -- contains

-- {-@ reflect contains @-}
-- contains :: List -> Int -> Bool
-- contains Nil y = False
-- contains (Cons x xs) y = if x == y then True else contains xs y

-- {-@ reflect contains' @-}
-- contains' :: List -> Int -> Bool
-- contains' xs y = exists (eq y) xs

-- {-@ automatic-instances contains_cons @-}
-- {-@
-- contains_cons ::
--   x:Int -> xs:List ->
--   {y:Int | contains (Cons x xs) y && not (x == y)} ->
--   {contains xs y}
-- @-}
-- contains_cons :: Int -> List -> Int -> Proof
-- contains_cons x Nil y = trivial
-- -- GOAL: if x' == y then True else contains xs y
-- contains_cons x (Cons x' xs) y =
--   if x' == y
--     -- GOAL: True
--     then trivial
--     -- GOAL: contains xs y
--     else trivial

-- -- minimum

-- {-@ reflect min @-}
-- {-@
-- min :: x:Int -> y:Int -> {z:Int | z <= x && z <= y}
-- @-}
-- min :: Int -> Int -> Int
-- min x y = if x <= y then x else y

-- {-@ reflect minimum @-}
-- {-@
-- minimum :: {xs:List | 0 < length xs} -> Int
-- @-}
-- minimum :: List -> Int
-- minimum (Cons x Nil) = x
-- minimum (Cons x xs) = min x (minimum xs)

-- -- -- * PASSES
-- -- {-@ reflect minimum_leq @-}
-- {-@ automatic-instances minimum_leq @-}
-- {-@
-- minimum_leq ::
--   {xs:List | 0 < length xs} ->
--   {all (leq (minimum xs)) xs}
-- @-}
-- minimum_leq :: List -> Proof
-- minimum_leq (Cons x Nil) = trivial
-- minimum_leq (Cons x1 (Cons x2 Nil)) = trivial
-- minimum_leq (Cons x1 (Cons x2 xs)) = undefined -- TODO
--   -- let m = minimum (Cons x1 (Cons x2 xs)) in
--   -- if m == x1 then
--   --   -- GOAL: all (leq (min x1 (minimum (Cons x2 xs)))) (Cons x1 (Cons x2 xs))
--   --   -- GOAL: leq x1 (min x1 (minimum (Cons x2 xs))) &&
--   --   --       all (leq (min x1 (minimum (Cons x2 xs)))) (Cons x2 xs)
--   --   trivial
--   -- else
--   --   undefined

-- -- minimum_leq (Cons x xs) =
-- --   let m = minimum (Cons x xs) in
-- --   if x == m then
-- --     trivial
-- --   else
-- --     minimum_leq xs

-- --   if x == y
-- --     then trivial
-- --     else unreachable
-- -- minimum_leq (Cons x xs) y =
-- --   if x == y
-- --     then trivial
-- --     else minimum_leq xs y

-- -- -- -- * PASSES
-- -- {-@ reflect minimum_leq @-}
-- -- {-@ automatic-instances minimum_leq @-}
-- -- {-@
-- -- minimum_leq ::
-- --   {xs:List | 0 < length xs} -> {y:Int | contains xs y} ->
-- --   {minimum xs <= y}
-- -- @-}
-- -- minimum_leq :: List -> Int -> Proof
-- -- minimum_leq (Cons x Nil) y =
-- --   if x == y
-- --     then trivial
-- --     else unreachable
-- -- minimum_leq (Cons x xs) y =
-- --   if x == y
-- --     then trivial
-- --     else minimum_leq xs y

-- -- * PASSES
-- {-@ reflect minimum_contains @-}
-- {-@ automatic-instances minimum_contains @-}
-- {-@
-- minimum_contains ::
--   {xs:List | 0 < length xs} ->
--   {contains xs (minimum xs)}
-- @-}
-- minimum_contains :: List -> Proof
-- -- GOAL: if x == y then True else contains Nil x
-- minimum_contains (Cons x Nil) = trivial
-- -- GOAL: if x == min x (minimum xs) then True else contains xs (min x (minimum xs))
-- minimum_contains (Cons x xs) =
--   if x <= min x (minimum xs)
--     -- GOAL: True
--     then trivial
--     -- GOAL: if x == minimum xs then True else contains xs (minimum xs)
--     else
--       if x == minimum xs
--         then trivial
--         else minimum_contains xs

-- {-@
-- minimum_permuted ::
--   {xs:List | 0 < length xs} ->
--   {ys:List | permuted xs ys} ->
--   {minimum xs == minimum ys}
-- @-}
-- minimum_permuted :: List -> List -> Proof
-- minimum_permuted xs ys = undefined -- TODO

-- -- singleton

-- {-@ reflect singleton @-}
-- singleton :: List -> Bool
-- singleton Nil = True
-- singleton (Cons x xs) = if contains xs x then False else singleton xs

-- {-@ automatic-instances singleton_cons @-}
-- {-@
-- singleton_cons ::
--   x:Int -> {xs:List | singleton xs && not (contains xs x)} ->
--   {singleton (Cons x xs)}
-- @-}
-- singleton_cons :: Int -> List -> Proof
-- singleton_cons x xs = trivial

-- {-@
-- singleton_snoc ::
--   x:Int -> {xs:List | singleton (Cons x xs)} ->
--   {singleton xs}
-- @-}
-- singleton_snoc :: Int -> List -> Proof
-- singleton_snoc x xs = undefined

-- {-@
-- singleton_without ::
--   {xs:List | 0 < length xs && singleton xs} -> {x:Int | contains xs x} ->
--   {singleton (without xs x)}
-- @-}
-- singleton_without :: List -> Int -> List
-- singleton_without xs x = undefined

-- -- without

-- {-@ reflect without @-}
-- without :: List -> Int -> List
-- without Nil y = Nil
-- without (Cons x xs) y = if x == y then xs else Cons x (without xs y)

-- -- {-@
-- -- without_verified ::
-- --   {xs:List | singleton xs && 0 < length xs} ->
-- --   {y:Int | contains xs y} ->
-- --   {xs':List | not (contains xs' y) && singleton xs' && length xs' = length xs - 1}
-- -- @-}
-- -- without_verified :: List -> Int -> List
-- -- without_verified xs y = without xs y

-- {-@ reflect without_contains'_aux @-}
-- {-@
-- without_contains'_aux ::
--   {xs:List | singleton xs && 0 < length xs} ->
--   {y:Int | contains xs y} ->
--   Int ->
--   Bool
-- @-}
-- without_contains'_aux :: List -> Int -> Int -> Bool
-- without_contains'_aux xs y z = contains (without xs y) z || z == y

-- {-@ automatic-instances without_contains' @-}
-- {-@
-- without_contains' ::
--   {xs:List | singleton xs && 0 < length xs} ->
--   {y:Int | contains xs y} ->
--   {all (without_contains'_aux xs y) xs}
-- @-}
-- without_contains' :: List -> Int -> Proof
-- without_contains' (Cons x Nil) y = trivial
-- without_contains' (Cons x xs) y =
--   -- GOAL: all (without_contains'_aux (Cons x xs) y) (Cons x xs)
--   -- GOAL: (contains (without (Cons x xs) y) x || x == y) && all (without_contains'_aux (Cons x xs) y) xs
--   -- GOAL: all (without_contains'_aux (Cons x xs) y) xs
--   undefined -- TODO

-- -- {-@ automatic-instances without_contains @-}
-- -- {-@
-- -- without_contains ::
-- --   {xs:List | singleton xs && 0 < length xs} ->
-- --   {y:Int | contains xs y} -> {z:Int | contains xs z && z /= y} ->
-- --   {contains (without xs y) z}
-- -- @-}
-- -- without_contains :: List -> Int -> Int -> Proof
-- -- without_contains (Cons x Nil) y z =
-- --   if x == y then
-- --     trivial
-- --   else
-- --     trivial
-- -- without_contains (Cons x1 (Cons x2 Nil)) y z =
-- --   if x1 == y then
-- --     if x2 == z
-- --       then trivial
-- --       else trivial
-- --   else
-- --     if x2 == y then
-- --       if x1 == z
-- --         then trivial
-- --         else trivial
-- --     else
-- --       trivial
-- -- -- GOAL: contains (without (Cons x1 (Cons x2 xs)) y) z
-- -- without_contains (Cons x1 (Cons x2 xs)) y z =
-- --   if x1 == y then
-- --     if x2 == z then
-- --       -- GOAL: True
-- --       trivial
-- --     else
-- --       -- GOAL: contains xs z
-- --       trivial
-- --   else
-- --     if x2 == y then
-- --       -- GOAL: contains (Cons x1 xs) z
-- --       if x1 == z then
-- --         trivial
-- --       else
-- --         -- GOAL: contains xs z
-- --         trivial
-- --     else
-- --       -- GOAL: contains (Cons x1 (without xs y)) z
-- --       if x1 == z then
-- --         -- GOAL: True
-- --         trivial
-- --       else
-- --         if x2 == z then
-- --           trivial
-- --         else
-- --           -- GOAL: contains (without xs y) z
-- --           without_contains xs y z

-- -- * PASSES
-- {-@ reflect without_length @-}
-- {-@ automatic-instances without_length @-}
-- {-@
-- without_length ::
--   xs:List -> {y:Int | contains xs y} ->
--   {length (without xs y) == length xs - 1}
-- @-}
-- without_length :: List -> Int -> Proof
-- -- CONTRA: contains Nil y == True
-- without_length Nil y = unreachable
-- without_length (Cons x xs) y =
--   if x == y
--     -- GOAL: length xs == length xs
--     then ()
--     -- GOAL: length (without xs y) == length xs
--     else without_length xs y

-- -- * PASSES
-- -- {-@ re   flect without_not_contains @-}
-- -- {-@ automatic-instances without_not_contains @-}
-- -- {-@
-- -- without_not_contains ::
-- --   {xs:List | singleton xs} -> {y:Int | contains xs y} ->
-- --   {not (contains (without xs y) y)}
-- -- @-}
-- -- without_not_contains :: List -> Int -> Proof
-- -- without_not_contains Nil y = unreachable
-- -- without_not_contains (Cons x xs) y =
-- --   if x == y
-- --     -- GOAL: not (contains xs y)
-- --     then ()
-- --     -- GOAL: not (contains (without xs y) y)
-- --     else without_not_contains xs y