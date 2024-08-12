import React from 'react';
import { Link, useNavigate } from 'react-router-dom';

const Header = () => {

    const navigate = useNavigate();

    const handleLogout = () => {
        // Clear the isLoggedIn status and token from localStorage
        localStorage.removeItem('isLoggedIn');
        localStorage.removeItem('token');
        // Set isLoggedIn state to false
        navigate('/login'); // Redirect to the login page or any other desired route
    };


    return (
        <>
            <nav className="navbar navbar-expand navbar-light bg-black topbar mb-4 static-top shadow">

                {/* Topbar Navbar */}
                <ul className="navbar-nav ml-auto">
                    {/* Nav Item - Search Dropdown (Visible Only XS) */}

                    {/* Nav Item - Alerts */}

                    {/* Nav Item - Messages */}

                    <div className="topbar-divider d-none d-sm-block" />
                    {/* Nav Item - User Information */}
                    <li className="nav-item dropdown no-arrow">
                        <a className="nav-link dropdown-toggle" href="#" id="userDropdown" role="button" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
                            <span className="mr-2 d-none d-lg-inline text-gray-600 small">Petlifes</span>
                            <img className="img-profile rounded-circle" src={process.env.PUBLIC_URL + '/img/ppp.png'} alt="Image Description" />
                        </a>
                        {/* Dropdown - User Information */}
                        <div className="dropdown-menu dropdown-menu-right shadow animated--grow-in" aria-labelledby="userDropdown">
                            {/* <a className="dropdown-item" href="#">
                                <i className="fas fa-user fa-sm fa-fw mr-2 text-gray-400" />
                                Profile
                            </a>
                            <a className="dropdown-item" href="#">
                                <i className="fas fa-cogs fa-sm fa-fw mr-2 text-gray-400" />
                                Settings
                            </a>
                            <a className="dropdown-item" href="#">
                                <i className="fas fa-list fa-sm fa-fw mr-2 text-gray-400" />
                                Activity Log
                            </a> */}
                            {/* <div className="dropdown-divider" /> */}
                            <Link
                                className="dropdown-item"
                                to="/"
                                data-toggle="modal"
                                data-target="#logoutModal"
                                onClick={handleLogout}
                            >
                                <i className="fas fa-sign-out-alt fa-sm fa-fw mr-2 text-gray-400" />
                                Logout
                            </Link>
                        </div>
                    </li>
                </ul>
            </nav>
            {/* End of Topbar */}

        </>
    )
}

export default Header;