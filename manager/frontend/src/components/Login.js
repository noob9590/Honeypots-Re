import React, { useState } from "react";
import { Redirect } from 'react-router-dom'
import axios from 'axios'
import { useAuth } from './context/auth'
import { MDBInput, MDBBtn, MDBCol, MDBRow, MDBContainer} from "mdbreact";
import '../index.css'




const Login = (props) => {

    const [isLoggedIn, setIsLoggedIn] = useState(false)
    const [isError, setIsError] = useState(false)
    const [username, setUserName] = useState("")
    const [password, setPassword] = useState("")
    const { setAuthTokens } = useAuth()

    const onFormSubmit = (e) => {
        e.preventDefault()
        axios.post("/login", { "username": username, "password": password })
            .then(result => {
                if (result.status === 200) {
                    setAuthTokens(result.data)
                    setIsLoggedIn(true)
                }
                else {
                    setIsError(true)
                }
            }).catch(e => {
                setIsError(true)
            })

    }

    if (isLoggedIn) {
        return <Redirect to='/dashboard' />
    }


    return (
        <div>
            <MDBContainer fluid style={{ height: "100vh" }} className="bg">
                <MDBRow center className="h-75">
                    <MDBCol size="3" middle className="border border-light">
                        <form onSubmit={onFormSubmit} style={{ padding: "1em" }}>
                            <p className="h5 text-center mb-4">Sign in</p>
                            <div className="grey-text">
                                <MDBInput
                                    labelClass="text-white"
                                    label="Type your email"
                                    icon="envelope"
                                    group
                                    type="text"
                                    className="text-white"
                                    validate
                                    error="wrong"
                                    success="right"
                                    getValue={value => setUserName(value)}
                                />
                                <MDBInput
                                    className="text-white"
                                    labelClass="text-white"
                                    label="Type your password"
                                    icon="lock"
                                    group
                                    type="password"
                                    validate
                                    getValue={value => setPassword(value)}
                                />
                            </div>
                            <div className="text-center">
                                <MDBBtn
                                    type="submit"
                                    onClick={onFormSubmit}
                                    className="loginBtn font-weight-light"
                                    outline
                                    color="white"

                                >

                                    Login
              </MDBBtn>
                            </div>
                        </form>
                    </MDBCol>
                </MDBRow>
            </MDBContainer>
        </div>
    );
};


export default Login
