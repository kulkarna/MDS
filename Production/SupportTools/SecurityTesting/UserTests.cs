using System;
using System.Text;
using System.Collections.Generic;
using System.Linq;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using UserBAL = LibertyPower.Business.CommonBusiness.SecurityManager;

namespace SecurityTesting
{
    [TestClass]
    public class UserTests
    {
        [TestMethod]
        public void TestGetUser()
        {
            UserBAL.User user = UserBAL.UserFactory.GetUser( 883 );

            Assert.IsNotNull( user );



        }


        [TestMethod]
        public void TestGetAllUsers()
        {
            UserBAL.UserList users = UserBAL.UserFactory.GetUsers();

            Assert.IsNotNull( users );
        }


        [TestMethod]
        public void TestRoles()
        {
            UserBAL.RoleList roles = UserBAL.RoleFactory.GetUserRoles();

            Assert.IsNotNull( roles );
            Assert.IsTrue( roles.Count > 0 );
        }



    }
}
