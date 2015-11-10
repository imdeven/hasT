import TORRENT
import BENCODE
import HTTP_REQ
import PEERS
import DATATYPES

import qualified Data.Map as Map
import Data.Map(Map)
import Text.ParserCombinators.Parsec
import Data.BEncode
import Data.ByteString.Lazy as B
import Data.ByteString.Lazy.Char8 as C
import Data.ByteString.Char8 as BC
import Crypto.Hash.SHA1 as SHA1
import Data.Byteable
import Network.Socket
import System.IO
import System.Random
import System.IO (hFlush, stdout)
import Data.Binary.Put

main = do
    let filename = "debian-8.2.0-amd64-lxde-CD-1.iso.torrent"
    
    myPeerId <- genPeerID

    tor <- makeTorrent filename myPeerId

    peerList <- getPeerList tor

    --handle <- connectPeers peerList
    connectPeers peerList

    --print "handle"
    --print handle
    --sendHandshake handle (infoHash tor) myPeerId
    --res <- receiveHandshake handle
    --print res
    --print $ validateHandshake res (infoHash tor)
    print "---END---" 

genPeerID :: IO BC.ByteString
genPeerID = do
              let a = 1000000000000 :: Integer
              randNum13 <- getStdRandom (randomR(a,9999999999999))
              let peerId = "-HB0001" ++ show randNum13
              return $ BC.pack peerId

getPeerList::Torrent -> IO [PeerAddress]
getPeerList tor = do
                    tcpSock <- makeTCPSock
                    temp <- socketPort tcpSock
                    let port = BC.pack $ show $ temp
                    peerList <- queryTracker tor port
                    return peerList