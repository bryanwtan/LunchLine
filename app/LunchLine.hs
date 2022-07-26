module LunchLine where

import Control.Monad.Logger
import Control.Monad.Reader
import Database.Persist.Sqlite
import Models
import Transformers.ReaderT (AppT, Env (Env), runAppT, runDB)

runApp :: AppT ()
runApp = do
  lineItems <- runDB $ do
    runMigration migrateAll
    insert_ $ LineItem "Pizza" 11
    insert_ $ LineItem "Burger" 12
    selectList [] []
  liftIO $ print (lineItems :: [Entity LineItem])

run :: IO ()
run = do
  env <- runStderrLoggingT $ Env <$> createSqlitePool ":memory:" 10
  runAppT runApp env

-- exercise: Figure out how to move the runMigration call to the main function.
-- exercise: Add {-# LANGUAGE TypeApplications #-} and use TypeApplications to clean up the :: [Entity Lineitem] type annotation
