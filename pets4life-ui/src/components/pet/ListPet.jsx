import React, { useEffect, useState } from 'react';
import Header from '../Header';
import SideBar from '../Sidebar';
import { Link } from 'react-router-dom';
import ReactPaginate from 'react-paginate';
import petService from '../../services/pet.service'
import {AiFillCaretLeft, AiFillCaretRight } from "react-icons/ai"; // icons form react-icons
import { IconContext } from "react-icons"; // for customizing icons
import "../../../src/my-styles.css"

const ListPet = () => {

    const [petList, setPetList] = useState([]);
    const [msg, setMsg] = useState('');
    const [searchTerm, setSearchTerm] = useState('');
    const [currentPage, setCurrentPage] = useState(0);
    const [petsPerPage] = useState(5);

    useEffect(() => {
        petService
            .getAllPet()
            .then((res) => {
                console.log(res.data);
                setPetList(res.data);

            })
            .catch((error) => {
                console.log(error);
            });
    }, []);

    const handleSearch = (event) => {
        setSearchTerm(event.target.value);
    };

    const filteredPets = petList
        .filter((pet) => {
            return (
                pet.petId.toString().toLowerCase().includes(searchTerm.toLowerCase()) ||
                pet.petName.toString().toLowerCase().includes(searchTerm.toLowerCase()) ||
                pet.petType.toString().toLowerCase().includes(searchTerm.toLowerCase()) ||
                pet.breed.toString().toLowerCase().includes(searchTerm.toLowerCase()) ||
                pet.gender.toString().toLowerCase().includes(searchTerm.toLowerCase()) ||
                pet.dateOfBirth.toString().toLowerCase().includes(searchTerm.toLowerCase()) ||
                pet.weight.toString().toLowerCase().includes(searchTerm.toLowerCase()) ||
                pet.currentDiet.toString().toLowerCase().includes(searchTerm.toLowerCase()) ||
                pet.note.toString().toLowerCase().includes(searchTerm.toLowerCase()) ||
                pet.imageProfile.toString().toLowerCase().includes(searchTerm.toLowerCase()) ||
                pet.createdDate.toString().toLowerCase().includes(searchTerm.toLowerCase()) ||
                pet.updatedDate.toString().toLowerCase().includes(searchTerm.toLowerCase()) ||
                pet.userId.toString().toLowerCase().includes(searchTerm.toLowerCase())

            );
        });

    const pageCount = Math.ceil(filteredPets.length / petsPerPage);

    const handlePageClick = (data) => {
        setCurrentPage(data.selected);
    };

    const offset = currentPage * petsPerPage;
    const currentPets = filteredPets.slice(offset, offset + petsPerPage);

    return (
        <>
            {/* Page Wrapper */}
            <div id="wrapper">
            <SideBar isAdmin={sessionStorage.getItem('isAdmin') === 'true'} isStaff={sessionStorage.getItem('isStaff') === 'true'} />
                {/* Content Wrapper */}
                <div id="content-wrapper" className="d-flex flex-column" style={{ backgroundImage: `url(/banner.jpg)`, backgroundSize: 'cover', height: '100vh' }}>
                    {/* Main Content */}
                    <div id="content">
                        <Header />
                        <div className="container-fluid">
                            {/* Page Heading */}
                            <h1 className="h3 mb-2" style={{ fontWeight: "revert", color: "#000", fontSize: "20px" }}>Pets</h1>

                            {msg && <p className="text-center text-success">{msg}</p>}

                            {/* Search Input */}
                            <div className="mb-3">
                                <input
                                    type="text"
                                    className="form-control"
                                    placeholder="Search"
                                    value={searchTerm}
                                    onChange={handleSearch}
                                />
                            </div>
                            {/* DataTales Example */}
                            <div className="card shadow mb-4">
                                <div className="card-body">
                                    <div className="table-responsive">
                                        <table className="table table-hover" id="" width="100%" cellSpacing="0">
                                            <thead style={{ color: "#000" }}>
                                                <tr>
                                                    <th>Image</th>
                                                    <th>Name</th>
                                                    <th>Type</th>
                                                    <th>Breed</th>
                                                    <th>Gender</th>
                                                    <th>DOB</th>
                                                    <th>Weight</th>
                                                    <th>Current Diet</th>
                                                    <th>Note</th>
                                                    <th>Created Date</th>
                                                    <th>Updated Date</th>
                                                    <th>Customer</th>
                                                </tr>
                                            </thead>
                                            <tbody>
                                                {currentPets.map((cus) => (
                                                    <tr key={cus.petId}>
                                                        <td>
                                                            <img src={cus.imageProfile} alt={cus.petName} width="100" height="100" />
                                                        </td>
                                                        <td>{cus.petName}</td>
                                                        <td>{cus.petType}</td>
                                                        <td>{cus.breed}</td>
                                                        <td>{cus.gender === true ? "Male" : "Female"}</td>
                                                        <td>{cus.dateOfBirth}</td>
                                                        <td>{cus.weight}</td>
                                                        <td>{cus.currentDiet}</td>
                                                        <td>{cus.note}</td>
                                                        <td>{cus.createdDate}</td>
                                                        <td>{cus.updatedDate === null ? "None" : cus.updatedDate}</td>
                                                        <td>{cus.userId}</td>
                                                        <td>
                                                            <div className="btn-group" role="group">
                                                                <Link to={`/edit_pet/${cus.petId}`}>
                                                                    <i class="far fa-edit text-warning"></i>
                                                                </Link>
                                                            </div>
                                                        </td>
                                                    </tr>
                                                ))}
                                            </tbody>
                                        </table>
                                    </div>
                                </div>
                            </div>

                            {/* Pagination */}
                            <div className='container-fluid'>
                                {/* Pagination */}
                                <div style={{ display: 'flex', justifyContent: 'center' }}>
                                    <ReactPaginate
                                        previousLabel={
                                            <IconContext.Provider value={{ color: "#B8C1CC", size: "23px" }}>
                                                <AiFillCaretLeft />
                                            </IconContext.Provider>
                                        }
                                        nextLabel={
                                            <IconContext.Provider value={{ color: "#B8C1CC", size: "23px" }}>
                                                <AiFillCaretRight />
                                            </IconContext.Provider>
                                        } breakLabel={'...'}
                                        breakClassName={'page-item'}
                                        breakLinkClassName={'page-link'}
                                        pageCount={pageCount}
                                        marginPagesDisplayed={2}
                                        pageRangeDisplayed={5}
                                        onPageChange={handlePageClick}
                                        containerClassName={'pagination'}
                                        activeClassName={'active'}
                                        previousClassName={'page-item'}
                                        nextClassName={'page-item'}
                                        pageClassName={'page-item'}
                                        previousLinkClassName={'page-link'}
                                        nextLinkClassName={'page-link'}
                                        pageLinkClassName={'page-link'}
                                    />
                                </div>

                            </div>
                        </div>
                        {/* /.container-fluid */}
                    </div>
                </div>
            </div>
        </>
    );
}

export default ListPet