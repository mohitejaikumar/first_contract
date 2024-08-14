import {
  Connection,
  PublicKey,
  clusterApiUrl,
} from "@solana/web3.js";
import {
transfer,
getOrCreateAssociatedTokenAccount
} from "@solana/spl-token";

 
// Playground wallet
const payer = pg.wallet.keypair;
const userPublicKey = new PublicKey('7R6C2jFctzrwUZ9N85qiHBbE2xdcQzq8QXpZYFcKRCyx');
 
// Connection to devnet cluster
const connection = new Connection(clusterApiUrl("devnet"), "confirmed");
const mint = new PublicKey('zXrV5XQLxvjFmmPGPF5hARLokViUE33KEg7rDBtqfuT');

try{
const fromTokenAccount = await getOrCreateAssociatedTokenAccount(
        connection,
        payer,
        mint,
        payer.publicKey
    );

    // Get the token account of the toWallet address, and if it does not exist, create it
const toTokenAccount = await getOrCreateAssociatedTokenAccount(connection, payer, mint, userPublicKey);


async function main(){

   for(let i=0;i<3;i++){
      try{
          await transfer(
          connection,
          payer,
          fromTokenAccount.address,
          toTokenAccount.address,
          payer,
          1000000000000
        );
      }
      catch(err){
        console.log(err);
      }
    
   }
}

main();
}
catch(err){
  console.log(err);
}


 
