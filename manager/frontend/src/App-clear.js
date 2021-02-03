import React, { useState } from "react"
import Login from './components/Login'
import PrivateRoute from './components/PrivateRoute'
import TopSearch from './components/Table'
import PillsPage from './components/Links'

import { BrowserRouter as Router, Route } from 'react-router-dom'
import { AuthContext } from "./components/context/auth"


function App() {

  const [authTokens, setAuthTokens] = useState()
  const setTokens = data => {
    localStorage.setItem("tokens", data)
    setAuthTokens(data)
  }

  return (
    <div>
      <AuthContext.Provider value={{ authTokens, setAuthTokens: setTokens }}>
        <Router>
          <Route exact path="/" component={Login} />
          <PrivateRoute path="/dashboard" component={PillsPage} />
        </Router>
      </AuthContext.Provider>
    </div>
  )
}

export default App