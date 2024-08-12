import { Link } from "react-router-dom"

const SideBar = ({ isAdmin, isStaff }) => {
    return (
        <>
            {/* Sidebar */}
            <ul className="navbar-nav sidebar sidebar-dark accordion" style={{ backgroundColor: "ThreeDHighlight" }} id="accordionSidebar">
                {/* Sidebar - Brand */}
                <Link className="sidebar-brand d-flex align-items-center justify-content-center" to="/home">
                    <div className="sidebar-brand-icon ">
                        <img className="img-profile rounded-circle" src={process.env.PUBLIC_URL + '/img/ppp.png'} alt="Image Description" style={{ width: 50 }} />

                    </div>
                    <div className="sidebar-brand-text mx-3">Pets4life</div>
                </Link>
                {/* Divider */}
                <hr className="sidebar-divider my-0" />
                {isAdmin && (
                    <li className="nav-item active">
                        <Link className="nav-link" to="/home">
                            <i className="fas fa-fw fa-tachometer-alt" />
                            <span>Dashboard</span></Link>
                    </li>
                )}
                {/* Divider */}
                <hr className="sidebar-divider" />
                {/* Heading */}
                <div className="sidebar-heading">
                    Management
                </div>
                {/* Nav Item - Utilities Collapse Menu */}

                {isStaff && (
                    <li className="nav-item">
                        <a className="nav-link collapsed" href="#" data-toggle="collapse" data-target="#collapseUtilities" aria-expanded="true" aria-controls="collapseUtilities">
                            <i class="fa fa-stethoscope" aria-hidden="true"></i>&nbsp;
                            <span>Appoinment </span>
                        </a>
                        <div id="collapseUtilities" className="collapse" aria-labelledby="headingUtilities" data-parent="#accordionSidebar">
                            <div className="bg-warning py-2 collapse-inner rounded">
                                <Link className="collapse-item" style={{ fontWeight: "bold" }} to="/list_appointments">List Appointment</Link>

                            </div>
                        </div>

                    </li>
                )}

                {isStaff && (
                    <li className="nav-item">
                        <a className="nav-link collapsed" href="#" data-toggle="collapse" data-target="#collapseUtilitiesv" aria-expanded="true" aria-controls="collapseUtilities">
                            <i class="fa fa-archive" aria-hidden="true"></i>&nbsp;
                            <span>Order </span>
                        </a>
                        <div id="collapseUtilitiesv" className="collapse" aria-labelledby="headingUtilities" data-parent="#accordionSidebar">
                            <div className="bg-warning py-2 collapse-inner rounded">
                                <Link className="collapse-item" style={{ fontWeight: "bold" }} to="/list_orders">List Order</Link>
                            </div>
                        </div>

                    </li>
                )}

                {isStaff && (
                    <li className="nav-item">
                        <a className="nav-link collapsed" href="#" data-toggle="collapse" data-target="#fff" aria-expanded="true" aria-controls="collapseUtilities">
                            <i class="fa fa-paw" aria-hidden="true"></i>&nbsp;
                            <span>Pet </span>
                        </a>
                        <div id="fff" className="collapse" aria-labelledby="headingUtilities" data-parent="#accordionSidebar">
                            <div className="bg-warning py-2 collapse-inner rounded">
                                <Link className="collapse-item" style={{ fontWeight: "bold" }} to="/list_pets">List Pet</Link>
                            </div>
                        </div>
                    </li>
                )}

                {isAdmin && (
                    <li className="nav-item">
                        <a className="nav-link collapsed" href="#" data-toggle="collapse" data-target="#collapseUtilitiess" aria-expanded="true" aria-controls="collapseUtilities">
                            <i class="fa fa-users" aria-hidden="true"></i>&nbsp;
                            <span>Customer </span>
                        </a>
                        <div id="collapseUtilitiess" className="collapse" aria-labelledby="headingUtilities" data-parent="#accordionSidebar">
                            <div className="bg-warning py-2 collapse-inner rounded">
                                <Link className="collapse-item" style={{ fontWeight: "bold" }} to="/list_customers">List Customer</Link>

                            </div>
                        </div>

                    </li>
                )}

                {isAdmin && (

                    <li className="nav-item">
                        <a className="nav-link collapsed" href="#" data-toggle="collapse" data-target="#collapseUtilitiesas" aria-expanded="true" aria-controls="collapseUtilities">
                            <i class="fa fa-id-badge" aria-hidden="true"></i>&nbsp;
                            <span>Staff </span>
                        </a>
                        <div id="collapseUtilitiesas" className="collapse" aria-labelledby="headingUtilities" data-parent="#accordionSidebar">
                            <div className="bg-warning py-2 collapse-inner rounded">
                                <Link className="collapse-item" style={{ fontWeight: "bold" }} to="/list_staffs">List Staff</Link>

                            </div>
                            <div className="bg-warning py-2 collapse-inner rounded">
                                <Link className="collapse-item" style={{ fontWeight: "bold" }} to="/add_staff">Add Staff</Link>

                            </div>
                        </div>

                    </li>
                )}

                {isStaff && (
                    <li className="nav-item">
                        <a className="nav-link collapsed" href="#" data-toggle="collapse" data-target="#collapseUtilitiesav" aria-expanded="true" aria-controls="collapseUtilities">
                            <i class="fa fa-id-badge" aria-hidden="true"></i>&nbsp;
                            <span>Product </span>
                        </a>
                        <div id="collapseUtilitiesav" className="collapse" aria-labelledby="headingUtilities" data-parent="#accordionSidebar">
                            <div className="bg-warning py-2 collapse-inner rounded">
                                <Link className="collapse-item" style={{ fontWeight: "bold" }} to="/list_products">List Product</Link>

                            </div>
                            <div className="bg-warning py-2 collapse-inner rounded">
                                <Link className="collapse-item" style={{ fontWeight: "bold" }} to="/add_product">Add Product</Link>

                            </div>
                        </div>

                    </li>
                )}

                {isStaff && (
                    <li className="nav-item">
                        <a className="nav-link collapsed" href="#" data-toggle="collapse" data-target="#collapseUtilitiesa" aria-expanded="true" aria-controls="collapseUtilities">
                            <i class="fa fa-american-sign-language-interpreting" aria-hidden="true"></i>&nbsp;
                            <span>Service </span>
                        </a>
                        <div id="collapseUtilitiesa" className="collapse" aria-labelledby="headingUtilities" data-parent="#accordionSidebar">
                            <div className="bg-warning py-2 collapse-inner rounded">
                                <Link className="collapse-item" style={{ fontWeight: "bold" }} to="/list_services">List Service</Link>

                            </div>
                        </div>
                        <div id="collapseUtilitiesa" className="collapse" aria-labelledby="headingUtilities" data-parent="#accordionSidebar">
                            <div className="bg-warning py-2 collapse-inner rounded">
                                <Link className="collapse-item" style={{ fontWeight: "bold" }} to="/add_service">Add Service</Link>

                            </div>
                        </div>
                    </li>
                )}

                {isAdmin && (

                    <li className="nav-item">
                        <a className="nav-link collapsed" href="#" data-toggle="collapse" data-target="#collapseUtilitiesass" aria-expanded="true" aria-controls="collapseUtilities">
                            <i class="fa fa-user-md" aria-hidden="true"></i>&nbsp;
                            <span>Veterinarian </span>
                        </a>
                        <div id="collapseUtilitiesass" className="collapse" aria-labelledby="headingUtilities" data-parent="#accordionSidebar">
                            <div className="bg-warning py-2 collapse-inner rounded">
                                <Link className="collapse-item" style={{ fontWeight: "bold" }} to="/list_veterinarians">List Veterinarian</Link>

                            </div>
                        </div>
                        <div id="collapseUtilitiesass" className="collapse" aria-labelledby="headingUtilities" data-parent="#accordionSidebar">
                            <div className="bg-warning py-2 collapse-inner rounded">
                                <Link className="collapse-item" style={{ fontWeight: "bold" }} to="/add_veterinarian">Add Veterinarian</Link>

                            </div>
                        </div>
                    </li>
                )}

            </ul>

            {/* End of Sidebar */}

        </>
    )
}

export default SideBar