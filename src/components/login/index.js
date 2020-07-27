import { getWeb3 } from '../../web3'
export default {
  name: 'Login',
  methods: {
    checkIfUserloggedIn() {

    },
    async loginUser() {
      try {
        this.web3 = await getWeb3();
      }
      catch(error) {

      }
    }
  },
}
