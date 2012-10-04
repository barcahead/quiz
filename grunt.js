module.exports = function(grunt) {

  grunt.initConfig({
    clean: {
      prod: ['prod'],
      debug: ['debug']
    },

    copy: {
      prod: {
        files: {
          'prod/node_modules/': 'node_modules/**',
          'prod/views/': 'views/**',
          'prod/public/bootstrap/': 'public/bootstrap/**',
          'prod/public/css/': 'public/css/**',
          'prod/public/image/': 'public/image/**'
        }
      },

      debug: {
        files: {
          'debug/views/': 'views/**',
          'debug/public/bootstrap/': 'public/bootstrap/**',
          'debug/public/css/': 'public/css/**',
          'debug/public/image/': 'public/image/**'
        }
      }
    },

    coffee: {
      prod: {
        files: {
          'prod/app.js': 'app.coffee',
          'prod/routes/*.js': ['routes/*.coffee'],
          'prod/public/js/app.js': ['public/js/*.coffee']
        }
      },

      debug: {
        files: {
          'debug/app.js': 'app.coffee',
          'debug/routes/*.js': ['routes/*.coffee'],
          'debug/public/js/*.js': ['public/js/*.coffee']
        }
      }
    },

    min: {
      dist: {
        src: ['prod/public/js/app.js'],
        dest: 'prod/public/js/app.js'
      }
    },

    mincss: {
      compress: {
        files: {
          'prod/public/css/app.css': ['public/css/app.css']
        }
      }
    }
  })

  grunt.loadNpmTasks('grunt-contrib-clean')
  grunt.loadNpmTasks('grunt-contrib-copy')
  grunt.loadNpmTasks('grunt-contrib-coffee')
  grunt.loadNpmTasks('grunt-contrib-mincss');

  grunt.registerTask('debug', 'clean:debug copy:debug coffee:debug')
  grunt.registerTask('prod', 'clean:prod copy:prod coffee:prod min mincss')

}