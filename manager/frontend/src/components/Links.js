import React, { Component } from 'react';
import { MDBContainer, MDBRow, MDBCol, MDBTabPane, MDBTabContent, MDBNav, MDBNavItem, MDBLink } from 'mdbreact';
import TopSearch from './Table'
import '../link.css'
import PrevTable from './PrevTable'

class PillsPage extends Component {
    state = {
        activeItemPills: '1'
    };

    togglePills = tab => () => {
        const { activePills } = this.state;
        if (activePills !== tab) {
            this.setState({
                activeItemPills: tab
            });
        }
    };

    render() {
        const { activeItemPills } = this.state;

        return (

            <MDBContainer fluid className="honeyPotTable">
                <MDBContainer fluid className="py-4">
                    <MDBRow>
                        <MDBCol md='12'>
                            <MDBNav className='nav-pills d-flex justify-content-center'>
                                <MDBNavItem className="">
                                    <MDBLink to='#' active={activeItemPills === '1'} onClick={this.togglePills('1')} link>
                                        Current Events
                    </MDBLink>
                                </MDBNavItem>
                                <MDBNavItem>
                                    <MDBLink to='#' active={activeItemPills === '2'} onClick={this.togglePills('2')} link>
                                        Previous Events
                    </MDBLink>
                                </MDBNavItem>
                            </MDBNav>
                            <MDBTabContent activeItem={activeItemPills}>
                                <MDBTabPane tabId='1'>
                                    <TopSearch />
                                </MDBTabPane>
                                <MDBTabPane tabId='2'>
                                <PrevTable/>
                                </MDBTabPane>
                            </MDBTabContent>
                        </MDBCol>
                    </MDBRow>
                </MDBContainer>
            </MDBContainer>
        );
    }
}

export default PillsPage;
