module Transformers.ReaderT where

import Control.Monad.Reader
import Data.Pool
import Database.Persist.Sqlite

newtype Env = Env {envPool :: Pool SqlBackend}

newtype AppT a = AppT {unAppT :: ReaderT Env IO a}
  deriving newtype (Functor, Applicative, Monad, MonadReader Env, MonadIO)

runAppT :: MonadIO m => AppT a -> Env -> m a
runAppT body env = liftIO $ runReaderT (unAppT body) env

runDB :: ReaderT SqlBackend IO a -> AppT a
runDB body = do
  pool <- asks envPool
  liftIO $ runSqlPool body pool

-- exercise: Try defining both SqlPersistT m a and DB a and try rewriting runDB in terms of them
-- exercise: Compare these implementations to mwb and how Yesod sets up this similar behavior.