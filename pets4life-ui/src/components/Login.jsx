import React, { useState } from 'react';
import { useNavigate, useParams } from 'react-router-dom';
import axios from 'axios';
import customerService from '../services/customer.service';


const Login = ({ setIsLoggedIn }) => { // Add setIsLoggedIn prop
    const [email, setEmail] = useState('');
    const [password, setPassword] = useState('');
    const [token, setBearerToken] = useState('');
    const [error, setError] = useState('');
    const navigate = useNavigate();

    const handleEmailChange = (e) => {
        setEmail(e.target.value);
    };

    const handlePasswordChange = (e) => {
        setPassword(e.target.value);
    };


    const handleSubmit = async (e) => {
        e.preventDefault();

        try {
            // Make the login request using the loginUser function
            const response = await customerService.loginUser(email, password); // Pass the email and password here
            // Check if the user has isAdmin set to true
            if (response.data.isAdmin === true || response.data.isStaff == true) {
                setIsLoggedIn(true); // Update the isLoggedIn state
                localStorage.setItem('isLoggedIn', 'true');
                console.log('localStorage:', localStorage.getItem('isLoggedIn'));

                // Store the email in sessionStorage
                sessionStorage.setItem('email', email); 
                sessionStorage.setItem('isAdmin', response.data.isAdmin); // Add this line
                sessionStorage.setItem('isStaff', response.data.isStaff); // Add this line
                navigate('/home');
            } else {
                setIsLoggedIn(false); // Update the isLoggedIn state
                setError('Login failed. Please try again.'); // Set the error message
            }
        } catch (error) {
            console.log('Login failed:', error);
            setIsLoggedIn(false); // Update the isLoggedIn state
            setError('Login failed. Please try again.'); // Set the error message
        }
    };

    return (
        
        <div className="container-fluid p-0 d-flex justify-content-center align-items-center" style={{ backgroundImage: `url(/banner.jpg)`, backgroundSize: 'cover', height: '100vh' }}>
            <div className="col-md-3 ">
                <div className="card">
                    <div className="card-body">
                        <h2 className="card-title text-center" style={{ color: "#000", fontWeight: "bold" }}>LOGIN</h2>
                        {error && <p className="text-danger">{error}</p>} {/* Display error message */}
                        <form onSubmit={handleSubmit}>
                            <div className="form-group">
                                <label htmlFor="email">Email:</label>
                                <input
                                    type="email"
                                    className="form-control"
                                    id="email"
                                    value={email}
                                    onChange={handleEmailChange}
                                    placeholder="Enter your email"
                                    required
                                />
                            </div>
                            <div className="form-group">
                                <label htmlFor="password">Password:</label>
                                <input
                                    type="password"
                                    id="password"
                                    value={password}
                                    onChange={handlePasswordChange}
                                    className="form-control"
                                    placeholder="Enter your password"
                                    required
                                />
                            </div>
                            <div className="text-center">
                                <button type="submit" className="btn" style={{ backgroundColor: "#ffbd58", color: "#000" }}>GO</button>
                            </div>
                        </form>
                    </div>
                </div>
            </div>
        </div>

    );
};

export default Login;